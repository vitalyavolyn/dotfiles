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
      age.secrets.hermes-dashboard-token = {
        file = ../../secrets/hermes-dashboard-token.age;
        owner = "hermes";
      };

      services.hermes-agent = {
        enable = true;
        settings = {
          model = {
            provider = "nvidia";
            default = "minimaxai/minimax-m3";
          };
          fallback_providers = [
            { provider = "nvidia"; model = "deepseek-ai/deepseek-v4-flash"; }
            { provider = "nvidia"; model = "nvidia/nemotron-3-ultra-550b-a55b"; }
            { provider = "nvidia"; model = "moonshotai/kimi-k3"; }
            { provider = "openrouter"; model = "nvidia/nemotron-3-ultra-550b-a55b:free"; }
          ];
          toolsets = [ "all" ];
          gateway.streaming.enabled = true;
        };
        extraDependencyGroups = [ "messaging" ];
        extraPackages = [ pkgs.chromium pkgs.ffmpeg ];
        environmentFiles = [
          config.age.secrets.hermes-env.path
        ];
        addToSystemPackages = true;
        backend = {
          mode = "dashboard";
          # A stable token instead of a random one per start — paste this
          # value into the Hermes Desktop app's Remote gateway -> Session
          # token field on applin/tynamo instead of each starting its own
          # separate agent.
          sessionTokenFile = config.age.secrets.hermes-dashboard-token.path;
        };
      };

      services.nginx.virtualHosts.${homelab.domainFor "hermes"}.locations."/".extraConfig = ''
        proxy_set_header Host 127.0.0.1;
      '';
    };
}
