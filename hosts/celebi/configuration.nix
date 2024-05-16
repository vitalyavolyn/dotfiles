{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    # hardware-specific config,
    # see also flake.nix -> nixos-hardware modules
    ./hardware-configuration.nix

    inputs.self.nixosProfiles.desktop-gnome
    inputs.self.nixosProfiles.home

    plymouth
    dev
    spotify
    qflipper
    keybase
    messaging
    torrent
    browser
    minecraft
    krita
    streaming
    vlc
  ];

  networking = {
    hostName = "celebi";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  nixpkgs.config = import ./nixpkgs-config.nix;

  system.stateVersion = "20.09";
}
