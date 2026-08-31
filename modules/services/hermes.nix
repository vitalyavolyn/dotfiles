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
      age.secrets.hermes-ssh-key = {
        file = ../../secrets/hermes-ssh-key.age;
        owner = "hermes";
      };

      system.activationScripts.hermesSshKey = {
        deps = [ "agenix" "users" ];
        text = ''
          install -d -m 0700 -o hermes -g hermes ${config.services.hermes-agent.stateDir}/home/.ssh
          install -m 0600 -o hermes -g hermes ${config.age.secrets.hermes-ssh-key.path} ${config.services.hermes-agent.stateDir}/home/.ssh/id_ed25519
          install -m 0644 -o hermes -g hermes ${pkgs.writeText "hermes-ssh-config" ''
            Host *.${homelab.tailnetName}
              User vitalya
              StrictHostKeyChecking accept-new
          ''} ${config.services.hermes-agent.stateDir}/home/.ssh/config
        '';
      };

      users.users.hermes = { extraGroups = [ "wheel" ]; };

      services.hermes-agent = {
        enable = true;
        settings = {
          model = {
            provider = "openrouter";
            default = "minimax/minimax-m3:free";
          };
          fallback_providers = [
            { provider = "nvidia"; model = "minimaxai/minimax-m3"; }
            { provider = "nvidia"; model = "deepseek-ai/deepseek-v4-flash"; }
            { provider = "nvidia"; model = "nvidia/nemotron-3-ultra-550b-a55b"; }
            { provider = "nvidia"; model = "moonshotai/kimi-k3"; }
            { provider = "openrouter"; model = "nvidia/nemotron-3-ultra-550b-a55b:free"; }
          ];
          toolsets = [ "all" ];
          gateway.streaming.enabled = true;
          platforms.telegram.extra.guest_mode = true;
        };
        extraDependencyGroups = [ "messaging" ];
        extraPackages = [
          pkgs.chromium
          pkgs.ffmpeg
          pkgs.openssh
          pkgs.nodejs
          pkgs.corepack
          pkgs.python3
          pkgs.python3Packages.pip
          pkgs.python3Packages.google-api-python-client
          pkgs.python3Packages.google-auth
          pkgs.python3Packages.google-auth-oauthlib
          pkgs.python3Packages.google-auth-httplib2
          pkgs.python3Packages.httplib2
          pkgs.python3Packages.pyasn1
        ];

        environmentFiles = [
          config.age.secrets.hermes-env.path
        ];
        addToSystemPackages = true;

        backend = {
          mode = "dashboard";
          sessionTokenFile = config.age.secrets.hermes-dashboard-token.path;
        };
        environment = {
          AGENT_BROWSER_EXECUTABLE_PATH = "/etc/profiles/per-user/hermes/bin/chromium";
        };
      };


      systemd.services.hermes-agent.serviceConfig.NoNewPrivileges = lib.mkForce false;
      systemd.services.hermes-backend.serviceConfig.NoNewPrivileges = lib.mkForce false;

      services.nginx.virtualHosts.${homelab.domainFor "hermes"}.locations."/".extraConfig = ''
        proxy_set_header Host 127.0.0.1;
      '';
    };
}
