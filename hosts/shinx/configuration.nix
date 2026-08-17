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
      firefox
      spotify
      logiops
      claude-code
      codex-cli
    ];

    nixos = { config, lib, ... }:
      let inherit (import ../../lib { inherit lib; }) homelab; in
      {
        imports = with inputs.nixos-hardware.nixosModules; [
          ./hardware-configuration.nix
          common-cpu-intel
          common-pc-ssd
        ];

        services.immich.mediaLocation = "/mnt/media/immich";
        services.home-assistant-container.volumes = [ "/mnt/media/home-assistant:/config" ];
        services.paperless.settings.PAPERLESS_URL = homelab.urlFor "paperless";

        services.paperless-concierge = {
          # TODO: why is this not in secrets?
          envFile = "/etc/paperless-concierge/.env";
        };

        services.cloudflared.eepoTunnel = {
          tunnelId = "ce5aebf4-adc5-4c20-85e2-d086c3f79079";
          credentialsFile = config.age.secrets.cloudflared-credentials.path;
          ingress = homelab.cloudflareIngressFor "shinx";
        };

        services.nginx.virtualHosts = homelab.privateVirtualHostsFor "shinx";

        age.secrets.cloudflared-credentials.file = ../../secrets/cloudflared-credentials.age;

        networking = {
          networkmanager.enable = true;
          firewall.enable = false;
        };

        services.tailscale.router = {
          exitNode = true;
          advertiseRoutes = [ "192.168.0.0/16" ];
        };

        services.tailscale.driveShares.media = "/mnt/media/downloads";

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
