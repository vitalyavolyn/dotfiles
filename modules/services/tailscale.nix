{ ... }:

{
  den.aspects.tailscale = {
    nixos = { config, lib, pkgs, ... }:
      let
        cfg = config.services.tailscale;
      in
      {
        options.services.tailscale = {
          router = {
            exitNode = lib.mkEnableOption "advertising this node as a Tailscale exit node";

            advertiseRoutes = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              example = [ "192.168.0.0/16" ];
              description = "Subnets to advertise as routes via this node (subnet router).";
            };
          };

          driveShares = lib.mkOption {
            type = lib.types.attrsOf lib.types.path;
            default = { };
            example = { media = "/mnt/media"; };
            description = ''
              Directories to publish as Taildrive shares, keyed by share name.
              Reconciled with `tailscale drive share`/`unshare` on activation.

              The tailnet ACL policy must separately grant this node the
              "drive:share" node attribute (and "drive:access" to nodes that
              should be able to mount shares) — that's tailnet-side config
              NixOS has no way to set. See https://tailscale.com/kb/1369/taildrive
            '';
          };
        };

        config = lib.mkMerge [
          {
            services.tailscale = {
              enable = true;
              extraSetFlags = [ "--operator=vitalya" ];
            };
            networking = {
              firewall.trustedInterfaces = [ "tailscale0" ];
              firewall.allowedUDPPorts = [ cfg.port ];
            };
          }

          (lib.mkIf (cfg.router.exitNode || cfg.router.advertiseRoutes != [ ]) (
            let
              routeFlags =
                lib.optional cfg.router.exitNode "--advertise-exit-node"
                ++ lib.optional (cfg.router.advertiseRoutes != [ ])
                  "--advertise-routes=${lib.concatStringsSep "," cfg.router.advertiseRoutes}";
            in
            {
              services.tailscale = {
                extraUpFlags = routeFlags;
                extraSetFlags = routeFlags;
                useRoutingFeatures = "both";
              };
            }
          ))

          (lib.mkIf (cfg.driveShares != { }) {
            systemd.services.tailscale-taildrive = {
              description = "Reconcile Taildrive shares";
              after = [ "tailscaled.service" "tailscaled-autoconnect.service" ];
              wants = [ "tailscaled.service" ];
              wantedBy = [ "multi-user.target" ];
              path = [ cfg.package pkgs.gawk ];
              serviceConfig = {
                Type = "oneshot";
                User = "vitalya";
              };
              enableStrictShellChecks = true;
              script = ''
                declare -A wanted=(
                ${lib.concatStringsSep "\n" (lib.mapAttrsToList
                  (name: path: "  [${lib.escapeShellArg name}]=${lib.escapeShellArg path}")
                  cfg.driveShares)}
                )

                while IFS= read -r name; do
                  [ -z "$name" ] && continue
                  if [ -z "''${wanted[$name]-}" ]; then
                    echo "Removing stale taildrive share: $name"
                    tailscale drive unshare "$name"
                  fi
                done < <(tailscale drive list | tail -n +3 | awk -F' {4,}' '{print $1}')

                for name in "''${!wanted[@]}"; do
                  echo "Sharing $name -> ''${wanted[$name]}"
                  tailscale drive share "$name" "''${wanted[$name]}"
                done
              '';
            };
          })
        ];
      };

    darwin.homebrew.casks = [ "tailscale" ];
  };
}
