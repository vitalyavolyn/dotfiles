{ config, den, lib, ... }:

let
  aspectInventory = lib.mapAttrs
    (_: hosts: lib.mapAttrs
      (_: host:
        lib.sort builtins.lessThan (
          lib.unique (map (aspect: aspect.identity) (builtins.filter
            (aspect:
              aspect.isNamed
              && aspect.identity != "default"
              && !(lib.hasPrefix "<" aspect.identity)
              && !(lib.hasInfix "/" aspect.identity))
            host.aspects))
        ))
      hosts)
    config.den.hosts;
in
{
  den.aspects.vitalya.includes = [
    den.batteries.define-user
    den.batteries.primary-user
    (den.batteries.user-shell "zsh")
    den.batteries.host-aspects
  ];

  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
  den.default.includes = [ den.batteries.hostname ];

  flake.lib = (import ./lib { inherit lib; }) // { inherit aspectInventory; };

  perSystem = { pkgs, ... }:
    let
      inventory = pkgs.writeText "aspect-inventory.json" (builtins.toJSON aspectInventory);
      aspects = pkgs.writeShellApplication {
        name = "aspects";
        runtimeInputs = [ pkgs.jq ];
        text = ''
          host="''${1:-}"
          if [ -z "$host" ]; then
            echo "usage: nix run .#aspects -- <host>" >&2
            exit 64
          fi

          jq -er --arg host "$host" '
            [to_entries[].value[$host]? // empty] as $matches
            | if ($matches | length) == 0
              then error("unknown host: " + $host)
              else $matches[] | .[]
              end
          ' ${inventory}
        '';
      };
    in
    {
      apps.aspects = {
        type = "app";
        program = lib.getExe aspects;
        meta.description = "List the Den aspects resolved for a host";
      };
    };
}
