# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, pkgs, ... }:

{
  # TODO: fingerprint reader
  imports = with inputs.self.nixosModules; [
    # hardware-specific config,
    # see also flake.nix -> nixos-hardware modules
    ./hardware-configuration.nix
    ./asus-rog-stuff.nix

    inputs.self.nixosProfiles.desktop-gnome

    tailscale
    avahi
    # plymouth
    dev
    { modules.dev.enable-nix-ld = true; }

    spotify
    qflipper
    messaging
    torrent
    firefox
    # chrome
    helium
    minecraft
    krita
    streaming
    vlc
    steam-run

    claude-desktop

    steam
    sunshine

    # flatpak
    solaar
  ];

  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

  # services.flatpak.packages = [
  #   "re.sonny.Workbench"
  # ];

  networking = {
    hostName = "tynamo";
    networkmanager.enable = true;
    firewall.enable = false;
  };

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
  home-manager.users.vitalya.home.stateVersion = "25.05";
}
