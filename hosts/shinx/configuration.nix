{ inputs, config, ... }:

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
    tailscale-exit-node
    avahi
    # docker
    firefox
    spotify

    # devon-server
  ];

  networking = {
    hostName = "shinx";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  # for devon
  # age.secrets.devon-env.file = ../../secrets/devon-env.age;
  # services.mongodb = {
  #   enable = true;
  #   bind_ip = "\"*\"";
  # };
  # services.devon-server.envFile = config.age.secrets.devon-env.path;

  services.plex = {
    enable = true;
    group = "multimedia";
  };
  services.tailscale = {
    extraUpFlags = [
      "--advertise-routes=192.168.0.0/16"
    ];
    extraSetFlags = [
      "--advertise-routes=192.168.0.0/16"
    ];
    useRoutingFeatures = "both";
  };

  # Autologin. This machine is connected to my TV.
  # https://github.com/NixOS/nixpkgs/issues/103746
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "vitalya";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  system.stateVersion = "23.11";
  home-manager.users.vitalya.home.stateVersion = "23.11";
}
