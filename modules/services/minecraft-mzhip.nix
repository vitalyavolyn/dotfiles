{ lib, config, ... }:

let
  cfg = config.modules.minecraft-mzhip;
in
{
  options.modules.minecraft-mzhip.volumes = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "Volumes to mount (needs /data)";
  };

  config = {
    age.secrets.curseforge-token.file = ../../secrets/curseforge-token.age;

    virtualisation.oci-containers.containers."minecraft-mzhip" = {
      autoStart = true;
      image = "docker.io/itzg/minecraft-server";
      volumes = cfg.volumes;
      environment = {
        TZ = "America/New_York";
        EULA = "TRUE";
        TYPE = "FABRIC";
        VERSION = "1.21.5";
        INIT_MEMORY = "4G";
        MAX_MEMORY = "19G";
        RCON_PASSWORD = "minecraft-mzhip";
        USE_AIKAR_FLAGS = "true";
      };
      environmentFiles = [
        config.age.secrets.curseforge-token.path
      ];
      ports = [ "0.0.0.0:2424:25565" "24454:24454/udp" ];
      extraOptions = [
        "--hostname=minecraft-mzhip"
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

    networking.firewall.allowedTCPPorts = [ 2424 ];
  };
}

