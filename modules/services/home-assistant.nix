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
    virtualisation.oci-containers.containers."homeassistant" = {
      volumes = cfg.volumes ++ lib.optionals cfg.addDbusVolume [ "/run/dbus:/run/dbus:ro" ];
      environment.TZ = config.time.timeZone;
      # TODO: add systemd timer to update images
      image = "ghcr.io/home-assistant/home-assistant:stable";
      extraOptions = [
        "--network=host"
        "--device=/dev/ttyACM0:/dev/ttyACM0"
      ];
    };

    networking.firewall.allowedTCPPorts = [ 8123 ];
  };
}
