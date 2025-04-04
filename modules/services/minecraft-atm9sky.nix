{ lib, config, ... }:

let
  cfg = config.modules.minecraft-atm9sky;
in
{
  options.modules.minecraft-atm9sky.volumes = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "Volumes to mount (needs /data)";
  };

  config = {
    age.secrets.curseforge-token.file = ../../secrets/curseforge-token.age;

    virtualisation.oci-containers.containers."minecraft-atm9sky" = {
      autoStart = true;
      image = "docker.io/itzg/minecraft-server:java17";
      volumes = cfg.volumes;
      environment = {
        TZ = "America/New_York";
        EULA = "TRUE";
        TYPE = "AUTO_CURSEFORGE";
        CF_SLUG = "all-the-mods-9-to-the-sky";
        INIT_MEMORY = "4G";
        MAX_MEMORY = "12G";
        RCON_PASSWORD = "all-the-mods-9-to-the-sky";
        USE_AIKAR_FLAGS = "true";
      };
      environmentFiles = [
        config.age.secrets.curseforge-token.path
      ];
      ports = [ "0.0.0.0:1775:25565" ];
      extraOptions = [
        "--hostname=minecraft-atm9sky"
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

    networking.firewall.allowedTCPPorts = [ 1775 ];
  };
}

