{ inputs, ... }:

{
  den.aspects.hermes.nixos = { config, pkgs, lib, ... }:
    let
      inherit (import ../../lib { inherit lib; }) homelab;
    in
    {
      imports = [
        inputs.hermes-agent.nixosModules.default
      ];

      age.secrets.hermes-env.file = ../../secrets/hermes-env.age;
      age.secrets.hermes-desktop-token = {
        file = ../../secrets/hermes-desktop-token.age;
        owner = "hermes";
      };

      services.hermes-agent = {
        enable = true;
        settings = {
          model = {
            provider = "nvidia";
            default = "nvidia/nemotron-3-super-120b-a12b";
          };
          toolsets = [ "all" ];
        };
        extraDependencyGroups = [ "messaging" ];
        extraPackages = [ pkgs.chromium pkgs.ffmpeg ];
        environmentFiles = [
          config.age.secrets.hermes-env.path
        ];
        addToSystemPackages = true;
        backend = {
          mode = "dashboard";
          # A stable token instead of a random one per start lets the
          # Hermes Desktop app on applin/tynamo authenticate against this
          # backend instead of each spinning up its own separate agent.
          sessionTokenFile = config.age.secrets.hermes-desktop-token.path;
        };
      };

      services.nginx.virtualHosts.${homelab.domainFor "hermes"}.locations."/".extraConfig = ''
        proxy_set_header Host 127.0.0.1;
      '';
    };
}
