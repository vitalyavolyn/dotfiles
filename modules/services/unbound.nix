{ ... }:

{
  den.aspects.unbound.nixos = { lib, config, ... }:
    let cfg = config.services.unbound.eepoZone; in
    {
      options.services.unbound.eepoZone = {
        tailnetName = lib.mkOption {
          type = lib.types.str;
          description = "Tailscale tailnet hostname suffix (e.g. tail1234.ts.net)";
          example = "tail1234.ts.net";
        };

        cloudflareNs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = ''
            Authoritative Cloudflare NS IPs for eepo.boo.
            Find these in the Cloudflare dashboard under DNS → Nameservers.
            Use the actual NS IPs, not 1.1.1.1.
          '';
          example = [ "108.162.192.7" "108.162.193.7" ];
        };

        localData = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = ''
            Private DNS A records for the eepo.boo zone pointing to Tailscale IPs.
            Public subdomains (foundryvtt, mc, ha via CF tunnel) should NOT be listed
            here — they are resolved by forwarding to Cloudflare's authoritative NS.
          '';
          example = [
            ''"plex.eepo.boo. IN A 100.68.131.102"''
          ];
        };

        interfaces = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            Extra addresses to listen on, besides loopback. Should be this node's
            Tailscale IP. Binding to a specific address (rather than 0.0.0.0)
            avoids grabbing port 53 on every interface, which otherwise conflicts
            with podman's aardvark-dns on per-network bridge gateways.
          '';
          example = [ "100.114.242.59" ];
        };
      };

      config = {
        # Allow tailnet devices to query this DNS server
        networking.firewall.interfaces."tailscale0" = {
          allowedTCPPorts = [ 53 ];
          allowedUDPPorts = [ 53 ];
        };

        services.unbound = {
          enable = true;
          settings = {
            server = {
              interface = lib.mkForce ([ "127.0.0.1" "::1" ] ++ cfg.interfaces);
              access-control = [ "100.0.0.0/8 allow" "127.0.0.0/8 allow" ];
              local-data = cfg.localData;
            };

            forward-zone = [
              # Resolve CNAME targets (*.ts.net) via Tailscale's internal DNS
              {
                name = "${cfg.tailnetName}.";
                forward-addr = "100.100.100.100";
              }
              # Forward public eepo.boo queries to Cloudflare's authoritative NS
              {
                name = "eepo.boo.";
                forward-addr = cfg.cloudflareNs;
              }
            ];
          };
        };
      };
    };
}
