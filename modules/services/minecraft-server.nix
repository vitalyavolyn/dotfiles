# Not a NixOS module — call this as a function to get one.
# Usage: import ./minecraft-server.nix { name = "..."; cfSlug = "..."; port = 1234; }
{ name, cfSlug, port, initMemory ? "4G", maxMemory ? "12G", javaVersion ? "java21" }:

{ lib, config, ... }:

let cfg = config.modules.${name}; in
{
  options.modules.${name}.volumes = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ "/mnt/extra/${name}/data:/data" ];
    description = "Volumes to mount (needs /data)";
  };

  config = {
    age.secrets.curseforge-token.file = ../../secrets/curseforge-token.age;

    virtualisation.oci-containers.containers.${name} = {
      autoStart = true;
      image = "docker.io/itzg/minecraft-server:${javaVersion}";
      volumes = cfg.volumes;
      environment = {
        TZ = "America/New_York";
        EULA = "TRUE";
        TYPE = "AUTO_CURSEFORGE";
        CF_SLUG = cfSlug;
        INIT_MEMORY = initMemory;
        MAX_MEMORY = maxMemory;
        RCON_PASSWORD = name;
        USE_AIKAR_FLAGS = "true";
      };
      environmentFiles = [ config.age.secrets.curseforge-token.path ];
      ports = [ "0.0.0.0:${toString port}:25565" ];
      extraOptions = [
        "--hostname=${name}"
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

    networking.firewall.allowedTCPPorts = [ port ];
  };
}
