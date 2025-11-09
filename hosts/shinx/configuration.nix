{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    # hardware-specific config,
    # see also flake.nix -> nixos-hardware modules
    ./hardware-configuration.nix

    inputs.self.nixosProfiles.desktop-gnome

    media-server
    { services.deluge.config.download_location = "/mnt/media/downloads/complete"; }

    home-assistant
    { modules.home-assistant.volumes = [ "/mnt/media/home-assistant:/config" ]; }

    podman-auto-prune

    paperless
    paperless-concierge
    paperless-ai
    {
      services.paperless-concierge = {
        # TODO: why is this not in secrets?
        envFile = "/etc/paperless-concierge/.env";
      };
    }

    tailscale
    avahi
    # docker
    firefox
    spotify
  ];

  networking = {
    hostName = "shinx";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  system.stateVersion = "23.11";

  # https://github.com/NixOS/nixpkgs/issues/103746
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "vitalya";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.create_ap = {
    enable = false;
    settings = {
      INTERNET_IFACE = "eno1";
      WIFI_IFACE = "wlp1s0";
      SSID = "shinx";
      # i know it's public
      # are you me neighbor? probably not
      # this is a temp solution, my access point is shit
      PASSPHRASE = "bulbasaur";
    };
  };

  home-manager.users.vitalya.home.stateVersion = "23.11";
}
