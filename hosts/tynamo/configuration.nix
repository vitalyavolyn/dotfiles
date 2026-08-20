# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ den, inputs, ... }:

{
  den.hosts.x86_64-linux.tynamo.users.vitalya = { };

  den.aspects.tynamo = {
    includes = with den.aspects; [
      desktop-gnome
      tailscale
      dev
      spotify
      todoist
      qflipper
      messaging
      torrent
      helium
      minecraft
      krita
      streaming
      vlc
      steam-run
      claude-desktop
      chatgpt-desktop
      steam
      sunshine
      logiops
    ];

    nixos = { pkgs, ... }:
      let
        # xrizer's nixpkgs packaging only ships a 64-bit vrclient.so
        # (lib/xrizer/bin/linux64). 32-bit (Win32) SteamVR games launched
        # through Proton need a matching 32-bit one alongside it, at
        # bin/linux32 - Steam's own preflight VR check uses the 64-bit path
        # and succeeds, but the actual 32-bit game process silently falls back
        # to a flat window with no error since it can't find a compatible
        # client library. See https://github.com/Supreeeme/xrizer/issues/326.
        # pkgsi686Linux.xrizer builds the 32-bit library but places it at
        # lib/xrizer/bin/vrclient.so (its own platformPaths convention), so we
        # copy both into one combined directory in the layout WiVRn/Proton
        # expect.
        xrizerCombined = pkgs.runCommand "xrizer-combined" { } ''
          mkdir -p $out/lib/xrizer/bin/linux64 $out/lib/xrizer/bin/linux32
          cp ${pkgs.xrizer}/lib/xrizer/bin/linux64/vrclient.so $out/lib/xrizer/bin/linux64/
          cp ${pkgs.pkgsi686Linux.xrizer}/lib/xrizer/bin/vrclient.so $out/lib/xrizer/bin/linux32/
        '';
      in
      {
        imports = with inputs.nixos-hardware.nixosModules; [
          ./hardware-configuration.nix
          ./asus-rog-stuff.nix
          common-cpu-amd
          common-pc-ssd
          common-pc-laptop
        ];

        programs.nix-ld.enable = true;

        services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

        networking = {
          networkmanager.enable = true;
          firewall.enable = false;
        };

        environment.systemPackages = with pkgs; [
          android-tools
          xrizer
        ];

        # OpenXR (native/wayvr) already works over WiVRn. SteamVR games use the
        # OpenVR API, which WiVRn doesn't speak directly - xrizer (above) bridges
        # OpenVR calls to WiVRn's OpenXR runtime, bypassing SteamVR's own headset
        # detection entirely. WiVRn auto-detects xrizer/OpenComposite on startup
        # and configures ~/.config/openvr/openvrpaths.vrpath itself; if a SteamVR
        # game still can't find a headset, check `journalctl --user -u wivrn` for
        # an "openvr" detection line and fall back to setting
        # services.wivrn.config.json."openvr-compat-path" explicitly.
        # xrizer input is overridden to xrizerCombined (see above) so 32-bit
        # SteamVR games work too, not just 64-bit ones.
        services.wivrn = {
          enable = true;
          openFirewall = true;
          autoStart = true;
          package = pkgs.wivrn.override {
            cudaSupport = true;
            xrizer = xrizerCombined;
          };
          steam.importOXRRuntimes = true;
          config = {
            enable = true;
            json = {
              application = [ pkgs.wayvr ];
            };
          };
        };

        # Steam sandboxes games via pressure-vessel, which blocks access to the
        # WiVRn IPC socket by default - without this, SteamVR games can't reach
        # WiVRn even once xrizer bridges the OpenVR calls.
        programs.steam.package = pkgs.steam.override {
          extraEnv = {
            PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_RUNTIME_DIR/wivrn/comp_ipc";
          };
        };

        # Fix for Tailscale subnet routing conflicting with local network.
        # A Tailscale subnet-routing peer advertises 192.168.0.0/16 into
        # Tailscale's own routing table, which the "from all lookup <table>"
        # ip-rule checks *before* the main table - so replies to devices on the
        # home LAN (e.g. the Quest 3 for WiVRn) get routed into the tailscale0
        # tunnel and silently vanish instead of going out over WiFi. Adding a
        # more specific /24 route for the home subnet into that same table
        # fixes it via longest-prefix-match. Only applies when wlp6s0 has a
        # 192.168.3.x address (i.e. at home).
        #
        # A timer re-applies this periodically because tailscaled resyncs its
        # routing table on its own schedule and silently wipes out
        # manually-added routes - relying solely on the network-up dispatcher
        # event was observed to leave the fix un-applied for extended periods.
        systemd.services.tailscale-local-route-fix = {
          description = "Ensure home LAN route takes precedence over tailscale subnet route";
          serviceConfig.Type = "oneshot";
          path = with pkgs; [ iproute2 gnugrep gnused ];
          script = ''
            set -eu
            ip addr show wlp6s0 | grep -q "192\.168\.3\." || exit 0
            TS_TABLE=$(ip route show table all | grep "100.100.100.100" | sed -n 's/.*table \([0-9]*\).*/\1/p' | head -1)
            [ -z "$TS_TABLE" ] && exit 0
            ip route replace 192.168.3.0/24 dev wlp6s0 table "$TS_TABLE"
          '';
        };

        systemd.timers.tailscale-local-route-fix = {
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "30s";
            OnUnitActiveSec = "20s";
          };
        };

        networking.networkmanager.dispatcherScripts = [{
          type = "basic";
          source = pkgs.writeText "tailscale-local-route" ''
            #!/bin/sh
            IFACE="$1"
            ACTION="$2"

            [ "$IFACE" = "wlp6s0" ] || exit 0

            case "$ACTION" in
              up)
                systemctl start --no-block tailscale-local-route-fix.service
                ;;
              down)
                TS_TABLE=$(ip route show table all | grep "100.100.100.100" | sed -n 's/.*table \([0-9]*\).*/\1/p' | head -1)
                [ -n "$TS_TABLE" ] && ip route del 192.168.3.0/24 dev wlp6s0 table "$TS_TABLE" 2>/dev/null || true
                exit 0
                ;;
            esac
          '';
        }];

        system.stateVersion = "25.05";
      };

    homeManager = {
      home.stateVersion = "25.05";

      xdg.configFile."autostart/rog-control-center.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=ROG Control Center
        Exec=rog-control-center
        X-GNOME-Autostart-enabled=true
      '';

      dconf = {
        enable = true;
        settings = {
          "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          ];
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "Launch4";
            command = "asusctl profile -n";
            name = "Next fan profile";
          };
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
            binding = "Launch1";
            command = "rog-control-center";
            name = "Open ROG control center";
          };
        };
      };
    };
  };
}
