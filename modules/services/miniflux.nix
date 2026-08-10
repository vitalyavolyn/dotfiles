{ ... }:

let
  credentialsFile = "/etc/miniflux/admin-credentials";
in
{
  config = {
    systemd.tmpfiles.rules = [ "d /etc/miniflux 0750 root root -" ];

    # Admin password generated once on first boot rather than committed to
    # git in plaintext (the old 2024 config did just that). Retrieve with:
    # sudo cat /etc/miniflux/admin-credentials
    systemd.services.miniflux-init-admin = {
      description = "Generate Miniflux admin credentials if missing";
      before = [ "miniflux.service" ];
      requiredBy = [ "miniflux.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        set -euo pipefail
        umask 077
        if [ ! -f ${credentialsFile} ]; then
          password="$(head -c 24 /dev/urandom | base64 | tr -d '/+=' | head -c 20)"
          cat > ${credentialsFile} <<EOF
        ADMIN_USERNAME=vitalya
        ADMIN_PASSWORD=$password
        EOF
        fi
      '';
    };

    services.miniflux = {
      enable = true;
      adminCredentialsFile = credentialsFile;
      config = {
        WORKER_POOL_SIZE = "5";
        POLLING_FREQUENCY = "60";
        BATCH_SIZE = "100";
        CLEANUP_ARCHIVE_READ_DAYS = "60";
        # Default (localhost:8080) collides with torrent.eepo.boo on shinx.
        # Bound to all interfaces (not just loopback) so podman containers
        # (e.g. larapaper) can reach it via host.containers.internal —
        # shinx's firewall is already disabled, so this doesn't change the
        # actual exposure, just who can dial in locally.
        LISTEN_ADDR = "0.0.0.0:8401";
      };
    };
  };
}
