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

      age.secrets.hermes-env = {
        file = ../../secrets/hermes-env.age;
        owner = "vitalya";
      };
      age.secrets.hermes-dashboard-token = {
        file = ../../secrets/hermes-dashboard-token.age;
        owner = "vitalya";
      };
      age.secrets.hermes-ssh-key = {
        file = ../../secrets/hermes-ssh-key.age;
        owner = "vitalya";
      };

      system.activationScripts.hermesSshKey = {
        deps = [ "agenix" "users" ];
        text = ''
          install -d -m 0700 -o vitalya -g users ${config.services.hermes-agent.stateDir}/home/.ssh
          install -m 0600 -o vitalya -g users ${config.age.secrets.hermes-ssh-key.path} ${config.services.hermes-agent.stateDir}/home/.ssh/id_ed25519
          install -m 0644 -o vitalya -g users ${pkgs.writeText "hermes-ssh-config" ''
            Host *.${homelab.tailnetName}
              User vitalya
              StrictHostKeyChecking accept-new
          ''} ${config.services.hermes-agent.stateDir}/home/.ssh/config
        '';
      };

      services.hermes-agent = {
        enable = true;
        user = "vitalya";
        group = "users";
        createUser = false;
        settings = {
          model = {
            provider = "openai-codex";
            default = "gpt-5.6-luna";
          };
          agent.reasoning_effort = "medium";
          approvals.mode = "smart";
          terminal = {
            backend = "local";
            cwd = "/var/lib/hermes/workspace";
          };
          web.backend = "parallel";
          stt.provider = "local";
          tts.provider = "edge";
          fallback_providers = [
            { provider = "nvidia"; model = "minimaxai/minimax-m3"; }
            { provider = "nvidia"; model = "deepseek-ai/deepseek-v4-flash"; }
            { provider = "nvidia"; model = "nvidia/nemotron-3-ultra-550b-a55b"; }
            { provider = "openrouter"; model = "nvidia/nemotron-3-ultra-550b-a55b:free"; }
          ];
          toolsets = [ "all" ];
          gateway.streaming.enabled = true;
          platforms.telegram.extra.guest_mode = true;
        };
        # Only include integrations used by this deployment. Hermes's `all`
        # group also pulls in unrelated adapters such as Home Assistant, SMS,
        # ACP, and YouTube.
        extraDependencyGroups = [
          "messaging"
          "google"
          "web"
          "youtube"
          "parallel-web"
          "voice"
          "edge-tts"
        ];
        extraPackages = [
          pkgs.chromium
          pkgs.codex
          pkgs.ffmpeg
          pkgs.gh
          pkgs.openssh
          pkgs.nodejs
          pkgs.corepack
          pkgs.python3
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
          AGENT_BROWSER_EXECUTABLE_PATH = "/etc/profiles/per-user/vitalya/bin/chromium";
          GH_CONFIG_DIR = "/home/vitalya/.config/gh";
        };
      };


      systemd.services.hermes-agent.serviceConfig.NoNewPrivileges = lib.mkForce false;
      systemd.services.hermes-agent.serviceConfig.ProtectSystem = lib.mkForce "off";
      # Direct-edit verification after rebuild.
      systemd.services.hermes-backend.serviceConfig.NoNewPrivileges = lib.mkForce false;
      systemd.services.hermes-backend.serviceConfig.ProtectSystem = lib.mkForce "off";

      services.nginx.virtualHosts.${homelab.domainFor "hermes"}.locations."/".extraConfig = ''
        proxy_set_header Host 127.0.0.1;
      '';
    };
}
