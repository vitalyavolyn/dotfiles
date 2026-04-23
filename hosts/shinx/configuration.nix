{ inputs, config, ... }:

let inherit (inputs.self.lib) tsOnly; in

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

    podman

    paperless
    paperless-concierge
    paperless-ai
    {
      services.paperless-concierge = {
        # TODO: why is this not in secrets?
        envFile = "/etc/paperless-concierge/.env";
      };
    }

    alloy

    cloudflared
    {
      modules.cloudflared = {
        tunnelId = "ce5aebf4-adc5-4c20-85e2-d086c3f79079";
        credentialsFile = config.age.secrets.cloudflared-credentials.path;
        ingress."ha.eepo.boo" = "http://localhost:8123";
      };
    }

    acme-eepo
    nginx
    {
      services.nginx.virtualHosts = {
        "ha.eepo.boo" = tsOnly "http://localhost:8123";
        "plex.eepo.boo" = tsOnly "http://localhost:32400";
        "immich.eepo.boo" = tsOnly "http://localhost:2283";
        "paperless.eepo.boo" = tsOnly "http://localhost:28981";
        "jellyfin.eepo.boo" = tsOnly "http://localhost:8096";
        "sonarr.eepo.boo" = tsOnly "http://localhost:8989";
        "radarr.eepo.boo" = tsOnly "http://localhost:7878";
        "prowlarr.eepo.boo" = tsOnly "http://localhost:9696";
        "bazarr.eepo.boo" = tsOnly "http://localhost:6767";
        "paperless-ai.eepo.boo" = tsOnly "http://localhost:3000";
        "deluge.eepo.boo" = tsOnly "http://localhost:8112";
      };
    }

    tailscale
    tailscale-exit-node
    firefox
    spotify
    logiops
  ];

  age.secrets.cloudflared-credentials.file = ../../secrets/cloudflared-credentials.age;

  networking = {
    hostName = "shinx";
    networkmanager.enable = true;
    firewall.enable = false;
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

  # Prevent sleep/suspend — used as a server
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  system.stateVersion = "23.11";
  home-manager.users.vitalya.home.stateVersion = "23.11";
}
