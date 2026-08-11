{ den, inputs, ... }:

{
  den.hosts.x86_64-linux.shinx.users.vitalya = { };

  den.aspects.shinx = {
    includes = with den.aspects; [
      desktop-gnome
      immich
      media-server
      home-assistant
      podman
      paperless
      paperless-concierge
      paperless-ai
      larapaper
      miniflux
      cloudflared
      acme-eepo
      nginx
      tailscale
      tailscale-exit-node
      firefox
      spotify
      logiops
    ];

    nixos = { config, ... }:
      let inherit ((import ../../lib)) tsOnly; in
      {
        imports = with inputs.nixos-hardware.nixosModules; [
          ./hardware-configuration.nix
          common-cpu-intel
          common-pc-ssd
        ];

        services.immich.mediaLocation = "/mnt/media/immich";
        services.home-assistant-container.volumes = [ "/mnt/media/home-assistant:/config" ];
        services.paperless.settings.PAPERLESS_URL = "https://paperless.eepo.boo";

        services.paperless-concierge = {
          # TODO: why is this not in secrets?
          envFile = "/etc/paperless-concierge/.env";
        };

        services.cloudflared.eepoTunnel = {
          tunnelId = "ce5aebf4-adc5-4c20-85e2-d086c3f79079";
          credentialsFile = config.age.secrets.cloudflared-credentials.path;
          ingress."ha.eepo.boo" = "http://localhost:8123";
          ingress."trmnl.eepo.boo" = "http://localhost:4567";
          ingress."miniflux.eepo.boo" = "http://localhost:8401";
        };

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
          "torrent.eepo.boo" = tsOnly "http://localhost:8080";
          "trmnl.eepo.boo" = tsOnly "http://localhost:4567";
          "miniflux.eepo.boo" = tsOnly "http://localhost:8401";
        };

        age.secrets.cloudflared-credentials.file = ../../secrets/cloudflared-credentials.age;

        networking = {
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
      };

    homeManager.home.stateVersion = "23.11";
  };
}
