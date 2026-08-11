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
      steam
      sunshine
      logiops
    ];

    nixos = { pkgs, ... }: {
      imports = with inputs.nixos-hardware.nixosModules; [
        ./hardware-configuration.nix
        ./asus-rog-stuff.nix
        common-cpu-amd
        common-pc-ssd
        common-pc-laptop
      ];

      nixpkgs.overlays = [ inputs.nixpkgs-xr.overlays.default ];

      programs.nix-ld.enable = true;

      services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

      networking = {
        networkmanager.enable = true;
        firewall.enable = false;
      };

      environment.systemPackages = with pkgs; [
        android-tools
      ];

      # services.wivrn = {
      #   enable = true;
      #   openFirewall = true;
      #   autoStart = true;
      #   package = pkgs.wivrn.override { cudaSupport = true; };
      #   steam.importOXRRuntimes = true;
      #   config = {
      #     enable = true;
      #     json = {
      #       application = [ pkgs.wayvr ];
      #     };
      #   };
      # };

      # Fix for Tailscale subnet routing conflicting with local network
      # Only adds the route when wlp6s0 has a 192.168.3.x address (i.e., at home)
      networking.networkmanager.dispatcherScripts = [{
        type = "basic";
        source = pkgs.writeText "tailscale-local-route" ''
          #!/bin/sh
          IFACE="$1"
          ACTION="$2"

          [ "$IFACE" = "wlp6s0" ] || exit 0

          # Find Tailscale's routing table (has 100.100.100.100 route)
          TS_TABLE=$(ip route show table all | grep "100.100.100.100" | sed -n 's/.*table \([0-9]*\).*/\1/p' | head -1)
          [ -z "$TS_TABLE" ] && exit 0

          case "$ACTION" in
            up)
              if ip addr show wlp6s0 | grep -q "192\.168\.3\."; then
                ip route add 192.168.3.0/24 dev wlp6s0 table "$TS_TABLE" 2>/dev/null || true
              fi
              ;;
            down)
              ip route del 192.168.3.0/24 dev wlp6s0 table "$TS_TABLE" 2>/dev/null || true
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
