{ inputs, ... }:

{
  den.aspects.umami.nixos = { ... }:
    let
      secretFile = "/etc/umami/app-secret";
    in
    {
      systemd.tmpfiles.rules = [ "d /etc/umami 0750 root root -" ];

      systemd.services.umami-init-secret = {
        description = "Generate Umami APP_SECRET if missing";
        before = [ "umami.service" ];
        requiredBy = [ "umami.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          set -euo pipefail
          umask 077
          if [ ! -f ${secretFile} ]; then
            head -c 32 /dev/urandom | base64 > ${secretFile}
          fi
        '';
      };

      services.umami = {
        enable = true;
        settings = {
          APP_SECRET_FILE = secretFile;
          HOSTNAME = "0.0.0.0";
          PORT = inputs.self.lib.homelab.portFor "umami";
          DISABLE_TELEMETRY = true;
        };
      };
    };
}
