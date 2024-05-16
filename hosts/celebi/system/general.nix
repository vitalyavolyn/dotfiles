{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    inputs.self.nixosProfiles.desktop-gnome
    inputs.self.nixosProfiles.home

    plymouth
    vscode
    spotify
    qflipper
    keybase
    messaging
  ];

  networking = {
    hostName = "celebi";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  system.stateVersion = "20.09";
}
