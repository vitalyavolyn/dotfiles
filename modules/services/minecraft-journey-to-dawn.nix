{ lib, config, ... }:

let
  cfg = config.modules.minecraft-journey-to-dawn;
in
{
  options.modules.minecraft-journey-to-dawn.volumes = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "Volumes to mount (needs /data)";
  };

  config = {
    age.secrets.curseforge-token.file = ../../secrets/curseforge-token.age;

    virtualisation.oci-containers.containers."minecraft-journey-to-dawn" = {
      autoStart = true;
      image = "docker.io/itzg/minecraft-server:java21";
      volumes = cfg.volumes;
      environment = {
        TZ = "America/New_York";
        EULA = "TRUE";
        TYPE = "AUTO_CURSEFORGE";
        CF_SLUG = "journey-to-dawn";
        INIT_MEMORY = "4G";
        MAX_MEMORY = "12G";
        RCON_PASSWORD = "minecraft-journey-to-dawn";
        USE_AIKAR_FLAGS = "true";
      };
      environmentFiles = [
        config.age.secrets.curseforge-token.path
      ];
      ports = [
        "0.0.0.0:1349:25565"
      ];
      extraOptions = [
        "--hostname=minecraft-journey-to-dawn"
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
        "--pull=newer"
      ];
    };

    networking.firewall.allowedTCPPorts = [ 1349 ];
  };
}
