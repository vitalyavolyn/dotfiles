{ inputs, ... }:

{
  den.aspects.immich.nixos = { ... }: {
    services.immich = {
      enable = true;
      host = "0.0.0.0";
      port = inputs.self.lib.homelab.portFor "immich";
      accelerationDevices = null;
    };

    users.users.immich.extraGroups = [ "video" "render" ];
  };
}
