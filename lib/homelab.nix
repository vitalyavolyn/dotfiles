{ lib }:

let
  domain = "eepo.boo";
  tailnetName = "ewe-lizard.ts.net";

  nodes = {
    porygon.tailnetIp = "100.114.242.59";
    shinx.tailnetIp = "100.68.131.102";
  };

  # Every service gets private DNS and a tailnet-only proxy on its node.
  # `exposures` adds optional ingress through Porygon (`public`) or the
  # Cloudflare tunnel on Shinx (`cloudflare`).
  services = {
    foundry = {
      node = "porygon";
      port = 30000;
      backendPath = "/";
      exposures = [ "public" ];
    };
    git = {
      node = "porygon";
      port = 3002;
      exposures = [ "public" ];
    };

    ha = {
      node = "shinx";
      # Fixed by Home Assistant's host-networked container setup.
      port = 8123;
      exposures = [ "cloudflare" ];
    };
    plex = {
      node = "shinx";
      # Fixed upstream; the NixOS module has no port option.
      port = 32400;
    };
    immich = {
      node = "shinx";
      port = 2283;
    };
    paperless = {
      node = "shinx";
      port = 28981;
    };
    jellyfin = {
      node = "shinx";
      # Fixed upstream; the NixOS module has no port option.
      port = 8096;
    };
    sonarr = {
      node = "shinx";
      port = 8989;
    };
    radarr = {
      node = "shinx";
      port = 7878;
    };
    prowlarr = {
      node = "shinx";
      port = 9696;
    };
    bazarr = {
      node = "shinx";
      port = 6767;
    };
    torrent = {
      node = "shinx";
      port = 8080;
    };
    paperless-ai = {
      node = "shinx";
      port = 3000;
    };
    trmnl = {
      node = "shinx";
      port = 4567;
      exposures = [ "cloudflare" ];
    };
    miniflux = {
      node = "shinx";
      port = 8401;
      exposures = [ "cloudflare" ];
    };
  };

  domainFor = name: "${name}.${domain}";
  urlFor = name: "https://${domainFor name}";
  portFor = name: services.${name}.port;

  backendFor = localNode: service:
    let
      host =
        if service.node == localNode
        then "localhost"
        else nodes.${service.node}.tailnetIp;
    in
    "http://${host}:${toString service.port}${service.backendPath or ""}";

  backendForService = localNode: name: backendFor localNode services.${name};

  servicesOn = node: lib.filterAttrs
    (_: service: service.node == node)
    services;

  servicesWithExposure = exposure: lib.filterAttrs
    (_: service: builtins.elem exposure (service.exposures or [ ]))
    services;

  privateVirtualHost = backend: {
    useACMEHost = domain;
    forceSSL = true;
    extraConfig = "allow 100.0.0.0/8; deny all;";
    locations."/" = { proxyPass = backend; proxyWebsockets = true; };
  };

  publicVirtualHost = backend: {
    useACMEHost = domain;
    forceSSL = true;
    locations."/" = { proxyPass = backend; proxyWebsockets = true; };
  };
in
{
  inherit domain tailnetName nodes services domainFor urlFor portFor backendForService;

  privateVirtualHostsFor = node: lib.mapAttrs'
    (name: service:
      lib.nameValuePair (domainFor name) (privateVirtualHost (backendFor node service)))
    (servicesOn node);

  publicVirtualHostsFor = edgeNode: lib.mapAttrs'
    (name: service:
      lib.nameValuePair (domainFor name) (publicVirtualHost (backendFor edgeNode service)))
    (servicesWithExposure "public");

  cloudflareIngressFor = edgeNode: lib.mapAttrs'
    (name: service:
      lib.nameValuePair (domainFor name) (backendFor edgeNode service))
    (servicesWithExposure "cloudflare");

  privateDnsRecords = lib.mapAttrsToList
    (name: service:
      let ip = nodes.${service.node}.tailnetIp;
      in ''"${domainFor name}. IN A ${ip}"'')
    services;
}
