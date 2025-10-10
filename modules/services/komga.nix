{ lib, config, ... }:

let
  cfg = config.modules.komga;
in
{
  options.modules.komga.port = lib.mkOption {
    type = lib.types.int;
    default = 23119;
    description = "Port to run Komga on";
  };
  options.modules.komga.stateDir = lib.mkOption {
    type = lib.types.str;
    default = "/var/lib/komga";
    description = "State directory for Komga";
  };

  config = {
    services.komga = {
      enable = true;
      stateDir = cfg.stateDir;
      settings = {
        server = {
          port = cfg.port;
        };
      };
    };
  };
}
