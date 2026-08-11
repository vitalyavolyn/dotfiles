// Synchronizes the work Calendar into the Google-backed "Work" calendar; macOS's
// own Google account sync (CalDAV, bidirectional) pushes those to real
// Google Calendar
//
// Events we create are tagged with a hidden marker in notes (tag() /
// extractUid()) so re-syncs only ever touch events we created ourselves.
//
// Env vars (all optional):
//   WORK_CAL_NAME          source calendar (default: Календарь -- the
//                          Work Exchange account's calendar; named after
//                          locale, not the account name)
//   WORK_CAL_DEST_NAME     destination calendar (default: Work)
//   WORK_CAL_DEST_SOURCE   destination's account name (default: Google)
//   WORK_CAL_DAYS          days ahead (default: 60)
//   WORK_CAL_DAYS_BACK     days back (default: 30)
//
// work-cal-export --debug-json prints fetched source events, no sync.

import EventKit
import Foundation

let tagPrefix = "[work-cal-export-uid:"
let tagSuffix = "]"

struct FetchedEvent {
    let uid: String
    let title: String
    let start: Date
    let end: Date
    let allDay: Bool
    let location: String
    let notes: String
    let url: String
}

func die(_ message: String) -> Never {
    FileHandle.standardError.write((message + "\n").data(using: .utf8)!)
    exit(1)
}

// Google Calendar truncates event descriptions at 8192 characters. Our
// tag must survive that truncation to stay trackable across syncs, so
// notes get truncated first to leave it room.
let maxNotesLength = 8000

func tag(notes: String, uid: String) -> String {
    let suffix = "\n\n" + tagPrefix + uid + tagSuffix
    let budget = max(0, maxNotesLength - suffix.count)
    let truncated = notes.count > budget ? String(notes.prefix(budget)) : notes
    return truncated.isEmpty ? String(suffix.dropFirst(2)) : truncated + suffix
}

func extractUid(fromNotes notes: String?) -> String? {
    guard let notes, let r1 = notes.range(of: tagPrefix) else { return nil }
    guard let r2 = notes.range(of: tagSuffix, range: r1.upperBound..<notes.endIndex) else { return nil }
    return String(notes[r1.upperBound..<r2.lowerBound])
}

func epochSeconds(_ d: Date) -> Int { Int(d.timeIntervalSince1970.rounded()) }

func findCalendar(_ store: EKEventStore, title: String, sourceTitle: String? = nil) -> EKCalendar? {
    store.calendars(for: .event).first {
        $0.title == title && (sourceTitle == nil || $0.source.title == sourceTitle)
    }
}

@main
struct Main {
    static func main() async {
        let env = ProcessInfo.processInfo.environment
        let sourceName = env["WORK_CAL_NAME"] ?? "Календарь"
        let destName = env["WORK_CAL_DEST_NAME"] ?? "Work"
        let destSource = env["WORK_CAL_DEST_SOURCE"] ?? "Google"
        let daysAhead = Int(env["WORK_CAL_DAYS"] ?? "") ?? 60
        let daysBack = Int(env["WORK_CAL_DAYS_BACK"] ?? "") ?? 30
        let debugJson = CommandLine.arguments.contains("--debug-json")

        let store = EKEventStore()
        let granted: Bool
        do {
            granted = try await store.requestFullAccessToEvents()
        } catch {
            granted = false
        }
        guard granted else {
            die("work-cal-export: Calendar access denied -- grant it under System Settings > Privacy & Security > Calendars, then try again")
        }

        let allCals = store.calendars(for: .event)
        let sourceCals = allCals.filter { $0.title == sourceName }
        guard !sourceCals.isEmpty else {
            let available = allCals.map { $0.title }
            die("work-cal-export: source calendar '\(sourceName)' not found (set WORK_CAL_NAME to one of: \(available.joined(separator: ", ")))")
        }

        let now = Date()
        let from = Foundation.Calendar.current.date(byAdding: .day, value: -daysBack, to: now)!
        let until = Foundation.Calendar.current.date(byAdding: .day, value: daysAhead, to: now)!

        let sourcePredicate = store.predicateForEvents(withStart: from, end: until, calendars: sourceCals)
        let rawEvents = store.events(matching: sourcePredicate)

        // eventIdentifier is shared across a recurring series, so fold in
        // startDate for a per-occurrence UID; also dedupes EventKit's
        // occasional duplicate occurrences.
        var seen = Set<String>()
        var sourceEvents: [FetchedEvent] = []
        for e in rawEvents {
            let uid = "\(e.eventIdentifier ?? UUID().uuidString)-\(Int(e.startDate.timeIntervalSince1970))"
            guard seen.insert(uid).inserted else { continue }
            sourceEvents.append(FetchedEvent(
                uid: uid,
                title: e.title ?? "Untitled",
                start: e.startDate,
                end: e.endDate,
                allDay: e.isAllDay,
                location: e.location ?? "",
                notes: e.notes ?? "",
                url: e.url?.absoluteString ?? ""
            ))
        }

        if debugJson {
            struct Ev: Codable {
                let uid: String, title: String, start: String, end: String
                let allDay: Bool, location: String, notes: String, url: String
            }
            let iso = ISO8601DateFormatter()
            iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let out = sourceEvents.map {
                Ev(uid: $0.uid, title: $0.title, start: iso.string(from: $0.start), end: iso.string(from: $0.end),
                   allDay: $0.allDay, location: $0.location, notes: $0.notes, url: $0.url)
            }
            if let data = try? JSONEncoder().encode(out), let s = String(data: data, encoding: .utf8) {
                print(s)
            } else {
                print("[]")
            }
            exit(0)
        }

        guard let destCal = findCalendar(store, title: destName, sourceTitle: destSource) else {
            let candidates = allCals.filter { $0.title == destName }.map { "\($0.title) (\($0.source.title))" }
            let hint = candidates.isEmpty ? "none found with that name" : "found but from a different account: \(candidates.joined(separator: ", "))"
            die("work-cal-export: destination calendar '\(destName)' from account '\(destSource)' not found (\(hint))")
        }
        guard destCal.allowsContentModifications else {
            die("work-cal-export: destination calendar '\(destName)' is not writable")
        }

        let destPredicate = store.predicateForEvents(withStart: from, end: until, calendars: [destCal])
        var existingByUid: [String: EKEvent] = [:]
        for e in store.events(matching: destPredicate) {
            if let uid = extractUid(fromNotes: e.notes) {
                existingByUid[uid] = e
            }
        }

        let sourceByUid = Dictionary(uniqueKeysWithValues: sourceEvents.map { ($0.uid, $0) })

        var created = 0, updated = 0, deleted = 0, unchanged = 0

        for src in sourceEvents {
            if let existing = existingByUid[src.uid] {
                let sameTime = epochSeconds(existing.startDate) == epochSeconds(src.start)
                    && epochSeconds(existing.endDate) == epochSeconds(src.end)
                let same = sameTime
                    && existing.title == src.title
                    && existing.isAllDay == src.allDay
                    && (existing.location ?? "") == src.location
                if same {
                    unchanged += 1
                    continue
                }
                existing.title = src.title
                existing.startDate = src.start
                existing.endDate = src.end
                existing.isAllDay = src.allDay
                existing.location = src.location
                existing.notes = tag(notes: src.notes, uid: src.uid)
                do {
                    try store.save(existing, span: .thisEvent, commit: false)
                    updated += 1
                } catch {
                    die("work-cal-export: failed to update event '\(src.title)': \(error)")
                }
            } else {
                let ev = EKEvent(eventStore: store)
                ev.calendar = destCal
                ev.title = src.title
                ev.startDate = src.start
                ev.endDate = src.end
                ev.isAllDay = src.allDay
                ev.location = src.location
                ev.notes = tag(notes: src.notes, uid: src.uid)
                do {
                    try store.save(ev, span: .thisEvent, commit: false)
                    created += 1
                } catch {
                    die("work-cal-export: failed to create event '\(src.title)': \(error)")
                }
            }
        }

        for (uid, existing) in existingByUid where sourceByUid[uid] == nil {
            do {
                try store.remove(existing, span: .thisEvent, commit: false)
                deleted += 1
            } catch {
                die("work-cal-export: failed to delete stale event '\(existing.title ?? uid)': \(error)")
            }
        }

        do {
            try store.commit()
        } catch {
            die("work-cal-export: failed to commit changes: \(error)")
        }

        print("work-cal-export: synced '\(sourceName)' -> '\(destName)' (\(destSource)): \(created) created, \(updated) updated, \(deleted) deleted, \(unchanged) unchanged")
    }
}
