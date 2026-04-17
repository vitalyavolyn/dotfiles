{ lib, config, pkgs, ... }:

{
  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    stateDir = "/mnt/extra/forgejo";
    database.type = "postgres";
    settings = {
      server = {
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3002;
        DOMAIN = "git.eepo.boo";
        ROOT_URL = "https://git.eepo.boo/";
        START_SSH_SERVER = false;
        SSH_DOMAIN = "git.eepo.boo";
        SSH_PORT = lib.head config.services.openssh.ports;
      };
      service.DISABLE_REGISTRATION = true;
      actions.ENABLED = true;
    };
  };
}
