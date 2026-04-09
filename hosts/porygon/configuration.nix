{ inputs, pkgs, config, ... }:

let
  # Public vhost with HTTP-01 ACME (vitalya.me domains)
  pub = backend: {
    addSSL = true;
    enableACME = true;
    locations."/" = { proxyPass = backend; proxyWebsockets = true; };
  };

  # Public vhost with wildcard cert (eepo.boo domains)
  pubEepo = backend: {
    useACMEHost = "eepo.boo";
    forceSSL = true;
    locations."/" = { proxyPass = backend; proxyWebsockets = true; };
  };

  # Tailscale-only vhost with wildcard cert, restricted to 100.0.0.0/8
  tsOnly = backend: {
    useACMEHost = "eepo.boo";
    forceSSL = true;
    extraConfig = "allow 100.0.0.0/8; deny all;";
    locations."/" = { proxyPass = backend; proxyWebsockets = true; };
  };
in
{
  imports = with inputs.self.nixosModules; [
    ./hardware-configuration.nix

    inputs.self.nixosProfiles.base-linux

    shadowsocks
    tailscale
    tailscale-exit-node

    foundry

    podman
    minecraft-create-chronicles
    {
      modules.minecraft-create-chronicles.volumes = [ "/mnt/extra/minecraft-create-chronicles/data:/data" ];
    }

    forgejo
    {
      services.postgresql.enable = true;
      services.postgresql.dataDir = "/mnt/extra/postgresql";
    }

    loki
    grafana
    alloy
    { modules.alloy.lokiUrl = "http://127.0.0.1:3100/loki/api/v1/push"; }

    unbound
    (
      let
        tailnet = "ewe-lizard.ts.net";
        a = ip: sub: ''"${sub}.eepo.boo. IN A ${ip}"'';
      in
      {
        modules.unbound = {
          tailnetName = tailnet;
          cloudflareNs = [ "108.162.194.108" "108.162.193.150" ]; # serenity + woz
          localData =
            # porygon
            map (a "100.114.242.59") [ "loki" "grafana" "git" ] ++
            # shinx
            map (a "100.68.131.102") [
              "ha"
              "plex"
              "immich"
              "paperless"
              "jellyfin"
              "sonarr"
              "radarr"
              "prowlarr"
              "bazarr"
              "deluge"
              "paperless-ai"
            ];
        };
      }
    )

    nginx
    {
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
            proxyPass = "http://shinx:7878/feed/v3/calendar/Radarr.ics";
          };
          locations."/cal/sonarr" = {
            proxyPass = "http://shinx:8989/feed/v3/calendar/Sonarr.ics";
          };
        };
        "hass.porygon.vitalya.me" = pub "http://shinx:8123/";
        "foundry.porygon.vitalya.me" = pub "http://localhost:30000/";

        # ── Public eepo.boo services ─────────────────────────────────────────

        "eepo.boo" = {
          useACMEHost = "eepo.boo";
          forceSSL = true;
          locations."/".return = "404";
        };

        "foundry.eepo.boo" = pubEepo "http://localhost:30000/";
        "git.eepo.boo" = pubEepo "http://localhost:3002";

        # ── Tailscale-only eepo.boo services ─────────────────────────────────

        "loki.eepo.boo" = tsOnly "http://localhost:3100";
        "grafana.eepo.boo" = tsOnly "http://localhost:3001";
      };
    }
  ];

  # Wildcard cert for eepo.boo via DNS-01 challenge (Cloudflare)
  age.secrets.cloudflare-acme.file = ../../secrets/cloudflare-acme.age;
  security.acme = {
    acceptTerms = true;
    defaults.email = "i@vitalya.me";
    certs."eepo.boo" = {
      group = "nginx";
      domain = "eepo.boo";
      extraDomainNames = [ "*.eepo.boo" ];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      webroot = null;
      environmentFile = config.age.secrets.cloudflare-acme.path;
    };
  };

  # alexander manages foundry
  users.users.sanyasuper2002 = {
    isNormalUser = true;
    extraGroups = [ "foundryvtt" "wheel" ];
    shell = pkgs.zsh;
    createHome = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdbYRTexJEZuXoOUt6XazFoL1MNgGoV2muVujWvrRGk raido@starlight"
    ];
  };

  networking = {
    hostName = "porygon";
    firewall.enable = true;
  };

  system.stateVersion = "24.05";

  home-manager.users.vitalya.home.stateVersion = "24.05";
}
