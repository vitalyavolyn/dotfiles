{ ... }:

{
  den.aspects.minecraft-vortex.nixos = { lib, config, ... }:
    let
      cfg = config.services.minecraft-vortex;
    in
    {
      options.services.minecraft-vortex.volumes = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "/mnt/extra/minecraft-vortex/data:/data"
          "/home/vitalya/vortex-1.1.2b-server.zip:/server-pack.zip:ro"
        ];
        description = "Volumes to mount (needs /data and pack zip at /server-pack.zip)";
      };

      config = {
        virtualisation.oci-containers.containers."minecraft-vortex" = {
          autoStart = true;
          image = "docker.io/itzg/minecraft-server:java17";
          volumes = cfg.volumes;
          environment = {
            TZ = "America/New_York";
            EULA = "TRUE";
            TYPE = "FORGE";
            VERSION = "1.20.1";
            FORGE_VERSION = "47.4.0";
            GENERIC_PACK = "/server-pack.zip";
            SERVER_PORT = "25565";
            INIT_MEMORY = "6G";
            MAX_MEMORY = "6G";
            RCON_PASSWORD = "minecraft-vortex";
            USE_AIKAR_FLAGS = "true";
          };
          ports = [ "0.0.0.0:25565:25565" ];
          extraOptions = [
            "--hostname=minecraft-vortex"
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

        networking.firewall.allowedTCPPorts = [ 25565 ];
      };
    };
}
