// faux quasar.yandex.net backend (nginx terminates TLS in front of this)
// PROXY mode: forward everything to real Yandex quasar backend untouched,
// EXCEPT get_sync_info: fetch the real device config and inject adbd keys.
const http = require('http');
const https = require('https');
const fs = require('fs');
const path = require('path');

const PORT = parseInt(process.env.PORT || '28700', 10);
const LOGDIR = process.env.LOGDIR || path.join(__dirname, 'logs');
fs.mkdirSync(LOGDIR, { recursive: true });

const REAL_HOST = 'quasar.yandex.ru';

const SYNC_INFO_MINI = JSON.stringify({
  status: 'ok',
  config: {
    account_config: { spotter: 'alisa' },
    device_config: { name: 'quasar' },
    system_config: {
      adbd: { remoteActivation: true, network: true },
    },
  },
  subscription: { mode: 'transaction' },
});

// env PAYLOAD=full|mini|xcmd  (xcmd = minimal + fully expanded adbd commands)
const PAYLOAD = process.env.PAYLOAD || 'full';
let flexCounter_ = 0;

const QUASAR = '/system/vendor/quasar';
function adbdSection(extra = {}) {
  return {
    remoteActivation: true,
    network: true,
    allDeactivateCmd: `${QUASAR}/activate_adb.sh --all deactivate`,
    quasmodromActivateCmd: `${QUASAR}/activate_adb.sh --quasmodrom activate`,
    quasmodromDeactivateCmd: `${QUASAR}/activate_adb.sh --quasmodrom --network deactivate`,
    quasmodromNetworkActivateCmd: `${QUASAR}/activate_adb.sh --quasmodrom activate --network`,
    ...extra,
  };
}

let REAL_CONFIG = null;
try {
  REAL_CONFIG = JSON.parse(fs.readFileSync(process.env.CONFIG_PATH || path.join(__dirname, 'real_config.json'), 'utf8'));
} catch (e) {
  REAL_CONFIG = { config: { system_config: {} } };
}

const SYNC_INFO_JOINT = JSON.stringify({
  status: 'ok',
  config: {
    ...REAL_CONFIG.config,
    adbd: adbdSection(),
    system_config: {
      ...REAL_CONFIG.config.system_config,
      adbd: adbdSection(),
    },
  },
  subscription: { mode: 'transaction' },
});

function log(...args) {
  const line = `[${new Date().toISOString()}] ${args.join(' ')}`;
  console.log(line);
  fs.appendFile(path.join(LOGDIR, 'server.log'), line + '\n', () => {});
}

function fetchReal(url) {
  return new Promise((resolve, reject) => {
    const req = https.get(url, { host: REAL_HOST, headers: { Host: REAL_HOST } }, res => {
      let data = '';
      res.on('data', d => { if (data.length < 4194304) data += d; });
      res.on('end', () => resolve({ status: res.statusCode, body: data }));
    });
    req.setTimeout(8000, () => req.destroy(new Error('timeout')));
    req.on('error', reject);
  });
}

http.createServer((req, res) => {
  log(`HTTP ${req.method} ${req.headers.host || '?'}${req.url} ua=${req.headers['user-agent'] || '-'}`);
  let body = '';
  req.on('data', d => { if (body.length < 4194304) body += d; });
  req.on('end', async () => {
    if (body) log('body:', body.slice(0, 600));
    const u = req.url;
    // fluent-bit log batches from the device (clck.yandex.net) — capture raw
    if (/write\/json\/batch|clck/i.test(u)) {
      let payload = body;
      try {
        if ((req.headers['content-encoding'] || '').includes('gzip')) {
          payload = require('zlib').gunzipSync(Buffer.from(body, 'binary')).toString('utf8');
        }
      } catch (e) { log('gunzip failed:', e.message); payload = body; }
      try {
        fs.appendFileSync(path.join(LOGDIR, 'device-fluentbit.log'), payload + '\n');
      } catch (e) { log('fluentbit capture failed:', e.message); }
      if (/write\/json\/batch/i.test(u)) {
        log('*** fluent-bit log batch captured:', payload.length, 'bytes ***');
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end('{"status":"ok"}');
        return;
      }
    }
    if (/glagol\/(v2\.0\/)?check_token/i.test(u)) {
      log('*** glagol check_token request (blessing as owner) ***');
      const isV1 = /\/glagol\/check_token/i.test(u);
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(isV1 ? '{"status":"ok","valid": true}' : '{"status":"ok","owner": true, "guest": false}');
      return;
    }
    if (/check_updates/i.test(u)) {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ hasUpdate: false, version: '0.0.0.0.0.0' }));
      log('*** update-suppression served hasUpdate=false ***');
      return;
    }
    if (/get_sync_info/i.test(u)) {
      if (PAYLOAD === 'soft' || PAYLOAD === 'softf') {
        const soft = JSON.parse(JSON.stringify(REAL_CONFIG));
        soft.config = soft.config || {};
        soft.config.system_config = soft.config.system_config || {};
        if (PAYLOAD === 'softf') {
          flexCounter_ += 1;
          soft.config.system_config.adbd = { remoteActivation: true, network: true, flex: flexCounter_ };
        } else {
          soft.config.system_config.adbd = { remoteActivation: true, network: true };
        }
        soft.config.system_config.syncd = Object.assign({}, soft.config.system_config.syncd, { pollPeriodSec: 3 });
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(soft));
        log(`*** served ${PAYLOAD.toUpperCase()} payload (real config + bool-only adbd, flex=${flexCounter_}) ***`);
        return;
      }
      if (PAYLOAD === 'pure') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(REAL_CONFIG));
        log('*** served PURE real config (no injections) ***');
        return;
      }
      if (PAYLOAD === 'joint') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(SYNC_INFO_JOINT);
        log('*** served JOINT payload (top-level + nested adbd) ***');
        return;
      }
      if (PAYLOAD === 'mini' || PAYLOAD === 'xcmd') {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(PAYLOAD === 'mini' ? SYNC_INFO_MINI : SYNC_INFO_XCMD);
        log(`*** served ${PAYLOAD.toUpperCase()} payload ***`);
        return;
      }
      try {
        const target = `https://${REAL_HOST}${u.split('?')[0]}?${u.split('?')[1] || ''}`;
        const r = await fetchReal(target);
        log(`real get_sync_info status=${r.status} len=${r.body.length}`);
        if (r.status === 200) {
          try {
            const j = JSON.parse(r.body);
            j.config = j.config || {};
            j.config.system_config = j.config.system_config || {};
            j.config.system_config.adbd = { remoteActivation: true, network: true };
            const out = JSON.stringify(j);
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(out);
            log('*** served REAL get_sync_info + adbd activation ***');
            return;
          } catch (e) { log('parse/mutate failed:', e.message); }
        }
      } catch (e) { log('real fetch failed:', e.message); }
      res.writeHead(502, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ code: 502, message: 'upstream failed' }));
      return;
    }
    // proxy everything else verbatim (no TLS MITM concerns upstream: plain HTTP here)
    const q = {
      hostname: REAL_HOST,
      port: 443,
      path: u,
      method: req.method,
      headers: { ...req.headers, host: REAL_HOST, 'accept-encoding': 'identity' },
    };
    delete q.headers['host'];
    q.headers = { ...req.headers, Host: REAL_HOST, 'accept-encoding': 'identity' };
    const preq = https.request(q, pres => {
      const headers = { ...pres.headers };
      if (headers['content-length']) headers['content-length'] = headers['content-length'];
      if (headers['transfer-encoding']) delete headers['transfer-encoding'];
      if (/family_device_list|device_list/i.test(u)) {
        let cap = '';
        pres.setEncoding('utf8');
        pres.on('data', d => { if (cap.length < 4194304) cap += d; });
        pres.on('end', () => {
          try {
            fs.writeFileSync(path.join(LOGDIR, 'glagol-device-list.json'), cap);
            log('*** captured glagol device_list:', cap.length, 'bytes ***');
          } catch (e) { log('capture failed:', e.message); }
          try { res.writeHead(pres.statusCode, headers); res.end(cap); } catch (_) {}
        });
        return;
      }
      res.writeHead(pres.statusCode, headers);
      pres.pipe(res);
      pres.on('data', () => {});
    });
    // stream body or chunks (we already buffered: send buffered body then don't wait for more)
    preq.on('error', e => {
      log('proxy error:', e.message);
      try { res.writeHead(502); res.end('{}'); } catch (_) {}
    });
    preq.end(body);
  });
}).listen(PORT, '127.0.0.1', () => log(`backend (proxy mode) up on 127.0.0.1:${PORT}`));
