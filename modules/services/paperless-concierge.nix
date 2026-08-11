{ inputs, ... }:

{
  den.aspects.paperless-concierge.nixos = { config, lib, pkgs, ... }:
    let
      cfg = config.services.paperless-concierge;
      defaultPackage = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.paperless-concierge;
    in
    {
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

        envFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to the environment file containing configuration.";
          example = "/etc/paperless-concierge/.env";
        };

        package = lib.mkOption {
          type = lib.types.package;
          default = defaultPackage;
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
        };

        users.groups.${cfg.group} = { };

        systemd.tmpfiles.settings."10-paperless-concierge".${cfg.dataDir}.d = {
          mode = "0700";
          user = cfg.user;
          group = cfg.group;
        };

        systemd.services.paperless-concierge = {
          description = "Paperless Concierge Telegram Bot";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
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
        };
      };
    };
}
