{ den, inputs, ... }:

{
  den.hosts.x86_64-linux.shinx.users.vitalya = { };

  den.aspects.shinx = {
    includes = with den.aspects; [
      base-linux
      avahi
      binbin
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
    ];

    nixos = { config, lib, pkgs, ... }:
      let
        inherit (import ../../lib { inherit lib; }) homelab;
      in
      {
        environment.systemPackages = [ pkgs.python3 ];

        imports = with inputs.nixos-hardware.nixosModules; [
          ./hardware-configuration.nix
          ./dev-db.nix
          common-cpu-intel
          common-pc-ssd
        ];

        services.immich.mediaLocation = "/mnt/media/immich";
        services.home-assistant-container.volumes = [ "/mnt/media/home-assistant:/config" ];
        services.paperless.settings.PAPERLESS_URL = homelab.urlFor "paperless";

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

        # ===== TEMP (yamini): fake quasar.yandex.net MITM to root the speaker =====
        # chain = forged quasar.yandex.net leaf + "EM DV TLS CA - G3C" cross-signed by
        # AAA Certificate Services (root trusted by ancient embedded stores).
        # serve-dv-aaa.pem/leaf.key copied manually into /var/lib/quasar-yamini.
        # TODO: nuke this whole block + service after speaker is rooted.
        services.nginx.virtualHosts = homelab.privateVirtualHostsFor "shinx" // {
          "quasar.yandex.net" = {
            onlySSL = true;
            listen = [{
              addr = "0.0.0.0";
              port = 443;
              ssl = true;
            }];
            sslCertificate = "/var/lib/quasar-yamini/serve-dv-aaa.pem";
            sslCertificateKey = "/var/lib/quasar-yamini/leaf.key";
            locations."/" = {
              proxyPass = "http://127.0.0.1:28700";
              extraConfig = "proxy_ssl_server_name off;";
            };
          };
          "clck.yandex.net" = {
            onlySSL = true;
            listen = [{
              addr = "0.0.0.0";
              port = 443;
              ssl = true;
            }];
            sslCertificate = "/var/lib/quasar-yamini/clck-serve-aaa.pem";
            sslCertificateKey = "/var/lib/quasar-yamini/clck.key";
            locations."/" = {
              proxyPass = "http://127.0.0.1:28700";
              extraConfig = "proxy_ssl_server_name off; client_max_body_size 64m;";
            };
          };
        };

        systemd.services.quasar-yamini = {
          description = "yamini: fake quasar.yandex.net get_sync_info backend (TEMP)";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          environment = {
            PORT = "28700";
            LOGDIR = "/var/lib/quasar-yamini/log";
            PAYLOAD = "softf";  # flexed + bool-only adbd
            CONFIG_PATH = builtins.toString (pkgs.writeText "real-config.json" (builtins.readFile ./real-config.json));
          };
          serviceConfig = {
            StateDirectory = "quasar-yamini";
            Restart = "on-failure";
          };
          script = ''
            exec ${pkgs.nodejs}/bin/node ${
              pkgs.writeText "quasar-yamini-serve.js" (builtins.readFile ./quasar-yamini-serve.js)
            }
          '';
        };
        # ===== END TEMP (yamini) =====

        age.secrets.cloudflared-credentials.file = ../../secrets/cloudflared-credentials.age;

        networking = {
          networkmanager.enable = true;
          firewall.enable = false;
        };

        services.tailscale.router = {
          exitNode = true;
          advertiseRoutes = [ "192.168.0.0/16" ];
        };

        # ===== TEMP (yamini): LAN DNS with quasar/clck pinned + AAAA nulled =====
        # The router override leaked real AAAA records, so the speaker connected
        # to Yandex over IPv6 and bypassed the MITM. This local-zone returns
        # NODATA for AAAA on the pinned domains (dnsmasq-style address=/ trick).
        services.unbound = {
          enable = true;
          settings = {
            server = {
              interface = [ "192.168.1.71" "127.0.0.1" ];
              access-control = [ "127.0.0.0/8 allow" "192.168.1.0/24 allow" ];
              local-zone = [
                ''"quasar.yandex.net." static''
                ''"clck.yandex.net." static''
                ''"quasar.yandex.ru." static''
                ''"quasar.s3.yandex.net." static''
                ''"cdnriqbxswemmatxzibl.svc.cdn.yandex.net." static''
              ];
              local-data = [
                ''"quasar.yandex.net. 600 IN A 192.168.1.71"''
                ''"clck.yandex.net. 600 IN A 192.168.1.71"''
                ''"quasar.yandex.ru. 600 IN A 192.168.1.71"''
                ''"quasar.s3.yandex.net. 600 IN A 192.168.1.71"''
                ''"cdnriqbxswemmatxzibl.svc.cdn.yandex.net. 600 IN A 192.168.1.71"''
                ''"dsldevice.lan. 600 IN A 192.168.1.1"''
              ];
            };
            forward-zone = [
              { name = "."; forward-addr = [ "77.88.8.8" "1.1.1.1" ]; }
            ];
          };
        };
        # ===== END TEMP (yamini) =====

        services.tailscale.driveShares.media = "/mnt/media/downloads";

        system.stateVersion = "23.11";
      };

    homeManager.home.stateVersion = "23.11";
  };
}
