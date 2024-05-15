{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    inputs.self.nixosProfiles.base
  ];

  networking = {
    hostName = "shinx";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  system.stateVersion = "23.11";

  users.groups.multimedia = {
    members = [ "vitalya" ];
  };
}
