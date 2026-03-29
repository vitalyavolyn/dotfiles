{ inputs, config, ... }:

{
  imports = with inputs.self.nixosModules; [
    # hardware-specific config,
    # see also flake.nix -> nixos-hardware modules
    ./hardware-configuration.nix

    inputs.self.nixosProfiles.desktop-gnome

    immich
    { services.immich.mediaLocation = "/mnt/media/immich"; }

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
    logiops
  ];

  networking = {
    hostName = "shinx";
    networkmanager.enable = true;
    firewall.enable = false;
  };

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

  system.stateVersion = "23.11";
  home-manager.users.vitalya.home.stateVersion = "23.11";
}
