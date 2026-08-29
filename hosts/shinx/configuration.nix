{ den, inputs, ... }:

{
  den.hosts.x86_64-linux.shinx.users.vitalya = { };

  den.aspects.shinx = {
    includes = with den.aspects; [
      base-linux
      avahi
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
      claude-code
      codex-cli
      forgejo-runner
      hermes
    ];

    nixos = { config, lib, ... }:
      let
        inherit (import ../../lib { inherit lib; }) homelab;
        developmentDatabase = "dev";
      in
      {
        imports = with inputs.nixos-hardware.nixosModules; [
          ./hardware-configuration.nix
          common-cpu-intel
          common-pc-ssd
        ];

        services.immich.mediaLocation = "/mnt/media/immich";
        services.home-assistant-container.volumes = [ "/mnt/media/home-assistant:/config" ];
        services.paperless.settings.PAPERLESS_URL = homelab.urlFor "paperless";

        services.postgresql = {
          ensureDatabases = [ developmentDatabase ];
          ensureUsers = [{
            name = developmentDatabase;
            ensureDBOwnership = true;
          }];
          settings.listen_addresses = lib.mkForce
            "localhost,${homelab.nodes.shinx.tailnetIp}";
          authentication = lib.mkAfter ''
            host ${developmentDatabase} ${developmentDatabase} ${homelab.nodes.applin.tailnetIp}/32 trust
          '';
        };

        services.redis.servers.dev = {
          enable = true;
          bind = homelab.nodes.shinx.tailnetIp;
          port = 6380;
          unixSocket = null;
          databases = 1;
          appendOnly = false;
          save = [ ];
          settings = {
            maxmemory = "128mb";
            maxmemory-policy = "allkeys-lru";
            protected-mode = "no";
          };
        };

        systemd.services.redis-dev.serviceConfig = {
          IPAddressDeny = "any";
          IPAddressAllow = [ homelab.nodes.applin.tailnetIp ];
        };

        # x86_64 runner, kept separate from porygon's ARM runner so
        # amd64-only jobs (image publishing) can target it specifically.
        age.secrets.forgejo-runner-token.file = ../../secrets/forgejo-runner-token-shinx.age;
        services.forgejo-runner.instances.default.settings = {
          runner.labels = [
            "linux-amd64:docker://node:current"
          ];
          server.connections.default = {
            url = "${homelab.urlFor "git"}/";
            uuid = "cab4cdec-1bc9-47eb-9b0a-b5648b880184";
          };
        };

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

        system.stateVersion = "23.11";
      };

    homeManager.home.stateVersion = "23.11";
  };
}
