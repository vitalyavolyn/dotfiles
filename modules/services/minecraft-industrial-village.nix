{ lib, config, ... }:

let
  cfg = config.modules.minecraft-insdustrial-village;
in
{
  options.modules.minecraft-insdustrial-village.volumes = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "Volumes to mount (needs /data)";
  };

  config = {
    virtualisation.oci-containers.containers."minecraft-insdustrial-village" = {
      autoStart = true;
      image = "docker.io/itzg/minecraft-server:java17";
      volumes = cfg.volumes;
      environment = {
        TZ = "America/New_York";
        EULA = "TRUE";
        TYPE = "AUTO_CURSEFORGE";
        CF_SLUG = "industrial-village";
        INIT_MEMORY = "10G";
        MAX_MEMORY = "16G";
        RCON_PASSWORD = "minecraft-insdustrial-village";
        USE_AIKAR_FLAGS = "true";
      };
      environmentFiles = [
        config.age.secrets.curseforge-token.path
      ];
      ports = [ "0.0.0.0:1337:25565" ];
      extraOptions = [
        "--hostname=minecraft-insdustrial-village"
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

    networking.firewall.allowedTCPPorts = [ 1337 ];
  };
}
