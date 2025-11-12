{ lib, config, ... }:

let
  cfg = config.modules.minecraft-chp;
in
{
  options.modules.minecraft-chp.volumes = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "Volumes to mount (needs /data)";
  };

  config = {
    age.secrets.curseforge-token.file = ../../secrets/curseforge-token.age;

    virtualisation.oci-containers.containers."minecraft-chp" = {
      autoStart = true;
      image = "docker.io/itzg/minecraft-server:java21";
      volumes = cfg.volumes;
      environment = {
        TZ = "America/New_York";
        EULA = "TRUE";
        TYPE = "AUTO_CURSEFORGE";
        CF_SLUG = "cave-horror-project";
        INIT_MEMORY = "4G";
        MAX_MEMORY = "12G";
        RCON_PASSWORD = "minecraft-chp";
        USE_AIKAR_FLAGS = "true";
        CF_EXCLUDE_MODS = "1133580";
      };
      environmentFiles = [
        config.age.secrets.curseforge-token.path
      ];
      ports = [
        "0.0.0.0:1349:25565"
        "0.0.0.0:8101:8100"
      ];
      extraOptions = [
        "--hostname=minecraft-chp"
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
