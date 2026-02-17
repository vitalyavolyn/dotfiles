{ ... }:

{
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    accelerationDevices = null;
  };

  users.users.immich.extraGroups = [ "video" "render" ];
}
