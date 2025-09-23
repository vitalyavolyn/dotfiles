# TODO: use flakes?
# TODO: heavily vibe-coded. needs manual cleanup
{ config, lib, pkgs, ... }:

let
  cfg = config.services.paperless-concierge;

  paperless-concierge = pkgs.python3.pkgs.buildPythonApplication {
    pname = "paperless-concierge";
    version = "0.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "mitchins";
      repo = "paperless-concierge";
      rev = "main";
      sha256 = "sha256-c7RGyxq1T2ot4CY6NnhMPPi5iz4TFS3Ne/eRDUOcht4=";
    };

    # Specify build system for modern Python packaging
    pyproject = true;
    build-system = with pkgs.python3.pkgs; [ setuptools setuptools-scm ];

    # Set version for setuptools-scm since we don't have git history
    preBuild = ''
      export SETUPTOOLS_SCM_PRETEND_VERSION="0.1.0"
    '';

    propagatedBuildInputs = with pkgs.python3.pkgs; [
      requests
      python-telegram-bot
      pyyaml
      python-dotenv
      aiofiles
      python-dateutil
      diskcache
      # Add more dependencies as needed based on setup.py
    ];

    # Don't run tests during build if they exist
    doCheck = false;

    meta = {
      description = "Telegram bot for Paperless-ngx";
      homepage = "https://github.com/mitchins/paperless-concierge";
      maintainers = [ ];
    };
  };

in
{
  # TODO: other modules use modules.*
  options.services.paperless-concierge = {
    user = lib.mkOption {
      type = lib.types.str;
      default = "paperless-concierge";
      description = "User account under which the service runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "paperless-concierge";
      description = "Group under which the service runs.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/paperless-concierge";
      description = "Directory for application data.";
    };

    # TODO: secrets
    envFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to the environment file containing configuration.";
      example = "/etc/paperless-concierge/.env";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = paperless-concierge;
      description = "The paperless-concierge package.";
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Extra environment variables to set for the service.";
      example = {
        PAPERLESS_URL = "https://paperless.example.com";
        LOG_LEVEL = "INFO";
      };
    };

    execStart = lib.mkOption {
      type = lib.types.str;
      default = "${cfg.package}/bin/paperless-concierge";
      description = "Command to start the service. Override if using start.sh script.";
      example = "${cfg.package}/start.sh";
    };
  };

  config = {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.${cfg.group} = { };

    systemd.services.paperless-concierge = {
      description = "Paperless Concierge Telegram Bot";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        ExecStart = cfg.execStart;
        Restart = "on-failure";
        RestartSec = 5;

        # Security settings
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.dataDir ];
        PrivateTmp = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
      } // lib.optionalAttrs (cfg.envFile != null) {
        EnvironmentFile = cfg.envFile;
      };

      environment = cfg.extraEnvironment;

      preStart = ''
        # Ensure data directory exists and has correct permissions
        mkdir -p ${cfg.dataDir}
        chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}
      '';
    };

    environment.systemPackages = [ cfg.package ];
  };
}
