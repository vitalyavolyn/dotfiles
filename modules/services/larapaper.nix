{ ... }:

let
  stateDir = "/var/lib/larapaper";
  envFile = "/etc/larapaper/env";
in
{
  config = {
    systemd.tmpfiles.rules = [
      # Owned by uid/gid 82 to match the container's internal www-data user
      # (rootful podman maps container UIDs 1:1 to host UIDs).
      "d ${stateDir}/database 0770 82 82 -"
      "d ${stateDir}/storage 0770 82 82 -"
      "d /etc/larapaper 0750 root root -"
    ];

    # Laravel APP_KEY (session/cookie encryption) — generated once on first
    # boot rather than committed to git, same spirit as Terminus's app-secret
    # generation. Not agenix-managed since it's cheap to rotate and lower
    # stakes than actual infra credentials.
    systemd.services.larapaper-init-env = {
      description = "Generate LaraPaper APP_KEY if missing";
      before = [ "podman-larapaper.service" ];
      requiredBy = [ "podman-larapaper.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        set -euo pipefail
        umask 077
        if [ ! -f ${envFile} ]; then
          key="base64:$(head -c 32 /dev/urandom | base64)"
          echo "APP_KEY=$key" > ${envFile}
        fi
      '';
    };

    virtualisation.oci-containers.containers."larapaper" = {
      autoStart = true;
      image = "ghcr.io/usetrmnl/larapaper:latest";
      pull = "newer";
      volumes = [
        "${stateDir}/database:/var/www/html/database/storage"
        "${stateDir}/storage:/var/www/html/storage/app/public/images/generated"
      ];
      environment = {
        APP_ENV = "production";
        APP_DEBUG = "false";
        APP_URL = "https://trmnl.eepo.boo";
        DB_CONNECTION = "sqlite";
        DB_DATABASE = "database/storage/database.sqlite";
        PHP_OPCACHE_ENABLE = "1";
        REGISTRATION_ENABLED = "1";
        # TLS is terminated upstream (Cloudflare tunnel / nginx); the
        # container only ever sees plain HTTP, so without these Laravel
        # generates http:// asset/URL links even on an https:// page.
        FORCE_HTTPS = "true";
        TRUSTED_PROXIES = "*";
      };
      ports = [ "127.0.0.1:4567:8080" ];
      extraOptions = [ "--env-file=${envFile}" ];
    };
  };
}
