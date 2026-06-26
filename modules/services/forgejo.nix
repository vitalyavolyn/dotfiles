{ lib, config, pkgs, ... }:

{
  # Host must set: stateDir, settings.server.{DOMAIN,ROOT_URL,SSH_DOMAIN}
  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    database.type = "postgres";
    settings = {
      server = {
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3002;
        START_SSH_SERVER = false;
        SSH_PORT = lib.head config.services.openssh.ports;
      };
      service.DISABLE_REGISTRATION = true;
      actions.ENABLED = true;
    };
  };
}
