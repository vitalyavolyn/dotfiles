{ pkgs, inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    inputs.self.nixosProfiles.desktop-gnome
  ];

  boot.plymouth.enable = true;

  networking = {
    hostName = "celebi";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  system.stateVersion = "20.09";
}
