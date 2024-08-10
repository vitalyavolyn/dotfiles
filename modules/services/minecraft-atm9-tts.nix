{ lib, config, ... }:

let
  cfg = config.modules.minecraft-atm9-tts;
in
{
  options.modules.minecraft-atm9-tts.volumes = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "Volumes to mount (needs /data)";
  };

  config = {
    age.secrets.curseforge-token.file = ../../secrets/curseforge-token.age;

    virtualisation.oci-containers.containers."minecraft-atm9-tts" = {
      autoStart = true;
      image = "docker.io/itzg/minecraft-server:java17";
      volumes = cfg.volumes;
      environment = {
        TZ = "America/New_York";
        EULA = "TRUE";
        TYPE = "AUTO_CURSEFORGE";
        CF_SLUG = "all-the-mods-9-to-the-sky";
        INIT_MEMORY = "10G";
        MAX_MEMORY = "16G";
        RCON_PASSWORD = "minecraft-atm9-tts";
        USE_AIKAR_FLAGS = "true";
      };
      environmentFiles = [
        config.age.secrets.curseforge-token.path
      ];
      ports = [ "0.0.0.0:1340:25565" ];
      extraOptions = [
        "--hostname=minecraft-atm9-tts"
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

    networking.firewall.allowedTCPPorts = [ 1340 ];
  };
}

