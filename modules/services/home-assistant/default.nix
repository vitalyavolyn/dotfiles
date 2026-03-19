{ lib, config, ... }:

let
  cfg = config.modules.home-assistant;
in
{
  options.modules.home-assistant.volumes = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "Volumes to mount (needs /config)";
  };

  options.modules.home-assistant.addDbusVolume = lib.mkOption {
    type = lib.types.bool;
    description = "D-Bus is optional but required if you plan to use the Bluetooth integration";
    default = true;
  };

  config = {
    environment.etc."home-assistant-patches/start.sh" = {
      source = ./start.sh;
      mode = "0755";
    };

    virtualisation.oci-containers.containers."homeassistant" = {
      volumes = cfg.volumes ++ lib.optionals cfg.addDbusVolume [ "/run/dbus:/run/dbus:ro" ] ++ [ "/etc/home-assistant-patches:/patches" ];
      environment.TZ = config.time.timeZone;
      image = "ghcr.io/home-assistant/home-assistant:stable";
      extraOptions = [
        "--network=host"
        "--pull=newer"
        "--cap-add=NET_ADMIN"
        "--cap-add=NET_RAW"
      ];
      entrypoint = "/patches/start.sh";
    };

    networking.firewall.allowedTCPPorts = [ 8123 ];
  };
}
