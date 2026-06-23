{ config, lib, ... }:

let
  cfg = config.modules.meme-search;
  networkName = "meme-search";
  networkSubnet = "10.89.0.0/24";
  databaseName = "meme_search";
  databaseUser = "meme_search";
  appImage = "ghcr.io/neonwatty/meme_search:latest";
  databaseUrl = "postgres://${databaseUser}@10.89.0.1:5432/${databaseName}";

  commonEnvironment = {
    DATABASE_URL = databaseUrl;
    IMAGE_DESCRIPTION_PROVIDER = "openai";
    OPENAI_API_BASE_URL = cfg.openaiApiBaseUrl;
    OPENAI_VISION_MODEL = cfg.visionModel;
  };

  commonVolumes = [
    "${cfg.memeLibraryDir}:/rails/public/memes/library:ro"
    "${cfg.directUploadsDir}:/rails/public/memes/direct-uploads"
  ];

  commonContainer = {
    autoStart = true;
    networks = [ networkName ];
    pull = "newer";
    extraOptions = [ "--env-file=${cfg.envFile}" ];
  };
in
{
  options.modules.meme-search = {
    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/media/meme-search";
      description = "Directory for meme-search writable state.";
    };

    memeLibraryDir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/media/memes";
      description = "Existing meme library to index, mounted read-only.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3010;
      description = "Host port for the meme-search web UI.";
    };

    envFile = lib.mkOption {
      type = lib.types.str;
      default = "/etc/meme-search/openrouter.env";
      description = "Environment file containing OPENAI_API_KEY.";
    };

    openaiApiBaseUrl = lib.mkOption {
      type = lib.types.str;
      default = "https://openrouter.ai/api/v1";
      description = "OpenAI-compatible API base URL.";
    };

    visionModel = lib.mkOption {
      type = lib.types.str;
      default = "openrouter/free";
      description = "OpenAI-compatible vision model slug.";
    };

    directUploadsDir = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Directory for drag-and-drop uploads.";
    };
  };

  config =
    let
      stateDir = cfg.stateDir;
    in
    {
      modules.meme-search = {
        directUploadsDir = "${stateDir}/direct-uploads";
      };

      services.postgresql = {
        enable = true;
        enableTCPIP = true;
        ensureDatabases = [ databaseName ];
        ensureUsers = [
          {
            name = databaseUser;
            ensureDBOwnership = true;
            ensureClauses.login = true;
          }
        ];
        authentication = ''
          host ${databaseName} ${databaseUser} ${networkSubnet} trust
        '';
        settings.listen_addresses = lib.mkForce "localhost,10.89.0.1";
      };

      systemd.services.postgresql-setup.serviceConfig.ExecStartPost = [
        ''
          ${config.services.postgresql.package}/bin/psql -d ${databaseName} -c 'CREATE EXTENSION IF NOT EXISTS vector;'
        ''
      ];

      systemd.tmpfiles.rules = [
        "d ${cfg.stateDir} 0755 root root -"
        "d ${cfg.memeLibraryDir} 0755 root root -"
        "d ${cfg.directUploadsDir} 0755 1000 1000 -"
        "d /etc/meme-search 0750 root root -"
      ];

      environment.etc."meme-search/openrouter.env.example".text = ''
        OPENAI_API_KEY=sk-or-v1-your-key-here
      '';

      systemd.services.podman-meme-search-network = {
        description = "Podman network for meme-search";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        path = [ config.virtualisation.podman.package ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          podman network exists ${networkName} || podman network create --subnet ${networkSubnet} --gateway 10.89.0.1 ${networkName}
        '';
      };

      virtualisation.oci-containers.containers = {
        "meme-search" = commonContainer // {
          image = appImage;
          environment = commonEnvironment;
          volumes = commonVolumes;
          ports = [ "127.0.0.1:${toString cfg.port}:3000" ];
        };

        "meme-search-jobs" = commonContainer // {
          image = appImage;
          cmd = [ "./bin/jobs" ];
          dependsOn = [ "meme-search" ];
          environment = commonEnvironment;
          volumes = commonVolumes;
        };
      };

      systemd.services = {
        postgresql = {
          requires = [ "podman-meme-search-network.service" ];
          after = [ "podman-meme-search-network.service" ];
        };

        podman-meme-search = {
          requires = [ "postgresql.service" "podman-meme-search-network.service" ];
          after = [ "postgresql.service" "podman-meme-search-network.service" ];
          unitConfig.RequiresMountsFor = [ cfg.stateDir cfg.memeLibraryDir ];
        };

        podman-meme-search-jobs = {
          requires = [ "postgresql.service" "podman-meme-search-network.service" ];
          after = [ "postgresql.service" "podman-meme-search-network.service" ];
          unitConfig.RequiresMountsFor = [ cfg.stateDir cfg.memeLibraryDir ];
        };
      };
    };
}
