{ lib, config, ... }:

let
  cfg = config.services.minecraft-aof6;
in
{
  options.services.minecraft-aof6.volumes = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "Volumes to mount";
  };

  config = {
    virtualisation.oci-containers.containers."minecraft-aof6" = {
      autoStart = true;
      image = "docker.io/itzg/minecraft-server:java17";
      volumes = cfg.volumes;
      environment = {
        TZ = "America/New_York";
        EULA = "TRUE";
        VERSION = "1.19.2";
        TYPE = "FABRIC";
        FABRIC_LAUNCHER_VERSION = "1.0.1";
        FABRIC_LOADER_VERSION = "0.14.25";
        INIT_MEMORY = "4G";
        MAX_MEMORY = "16G";
        RCON_PASSWORD = "minecraft-aof6";
        USE_AIKAR_FLAGS = "true";
      };
      ports = [ "0.0.0.0:1337:25565" ];
      extraOptions = [
        "--hostname=minecraft-aof6"
        "--health-cmd"
        "mc-health"
        "--health-interval"
        "10s"
        "--health-retries"
        "6"
        "--health-timeout"
        "1s"
        "--health-start-period"
        "20m"
      ];
    };
  };
}
