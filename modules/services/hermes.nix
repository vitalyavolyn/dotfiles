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
      age.secrets.hermes-dashboard-auth.file = ../../secrets/hermes-dashboard-auth.age;

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
          # HERMES_DASHBOARD_BASIC_AUTH_USERNAME/_PASSWORD — lets the
          # Hermes Desktop app on applin/tynamo sign in to this backend
          # (Settings -> Gateway -> Remote gateway) over the tailnet,
          # instead of each spinning up its own separate agent.
          config.age.secrets.hermes-dashboard-auth.path
        ];
        addToSystemPackages = true;
        backend.mode = "dashboard";
      };

      services.nginx.virtualHosts.${homelab.domainFor "hermes"}.locations."/".extraConfig = ''
        proxy_set_header Host 127.0.0.1;
      '';
    };
}
