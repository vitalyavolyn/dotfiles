{ den, ... }:

{
  den.hosts.aarch64-linux.porygon.users.vitalya.baseHome.extras = false;

  den.aspects.porygon = {
    includes = with den.aspects; [
      base-linux
      shadowsocks
      tailscale
      tailscale-exit-node
      foundry
      podman
      minecraft-vortex
      forgejo
      unbound
      acme-eepo
      nginx
      claude-code
      codex-cli
    ];

    nixos = { lib, pkgs, ... }:
      let
        inherit (import ../../lib { inherit lib; }) homelab;

        # Public vhost with HTTP-01 ACME (vitalya.me domains)
        pub = backend: {
          addSSL = true;
          enableACME = true;
          locations."/" = { proxyPass = backend; proxyWebsockets = true; };
        };
      in
      {
        imports = [ ./hardware-configuration.nix ];

        services.foundryvtt.hostName = homelab.domainFor "foundry";
        services.forgejo.stateDir = "/mnt/extra/forgejo";
        services.forgejo.settings.server = {
          DOMAIN = homelab.domainFor "git";
          ROOT_URL = "${homelab.urlFor "git"}/";
          SSH_DOMAIN = homelab.domainFor "git";
        };
        services.postgresql = {
          enable = true;
          dataDir = "/mnt/extra/postgresql";
        };

        services.unbound.eepoZone = {
          tailnetName = homelab.tailnetName;
          cloudflareNs = [ "108.162.194.108" "108.162.193.150" ]; # serenity + woz
          localData = homelab.privateDnsRecords;
        };

        services.nginx.clientMaxBodySize = "100m";
        services.nginx.virtualHosts = {
          "porygon.vitalya.me" = {
            addSSL = true;
            enableACME = true;
            locations."/" = {
              return = "200 'hiiii :3'";
              extraConfig = "add_header Content-Type text/plain;";
            };
            locations."/cal/radarr" = {
              proxyPass = "${homelab.backendForService "porygon" "radarr"}/feed/v3/calendar/Radarr.ics";
            };
            locations."/cal/sonarr" = {
              proxyPass = "${homelab.backendForService "porygon" "sonarr"}/feed/v3/calendar/Sonarr.ics";
            };
          };
          "foundry.porygon.vitalya.me" = pub (homelab.backendForService "porygon" "foundry");

          # ── Public eepo.boo services ─────────────────────────────────────────

          "${homelab.domain}" = {
            useACMEHost = homelab.domain;
            forceSSL = true;
            locations."/".return = "404";
          };
        }
        // (homelab.privateVirtualHostsFor "porygon")
        // (homelab.publicVirtualHostsFor "porygon");

        # alexander manages foundry
        users.users.sanyasuper2002 = {
          isNormalUser = true;
          extraGroups = [ "foundryvtt" "wheel" ];
          shell = pkgs.zsh;
          createHome = true;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdbYRTexJEZuXoOUt6XazFoL1MNgGoV2muVujWvrRGk raido@starlight"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMeWxlo7NgypRpXx5mjOgESmdfquy0ofICN6i29WTcf0"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPYJ29XuKpoFlrWQVvQtqW+zL/KMTG+Epxm34v6TFls3 raido@moonlight"
          ];
        };

        networking = {
          firewall.enable = true;
        };

        swapDevices = [{ device = "/mnt/extra/swapfile"; size = 8192; }];

        system.stateVersion = "24.05";
      };

    homeManager.home.stateVersion = "24.05";
  };
}
