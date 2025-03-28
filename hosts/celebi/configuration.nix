{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    # hardware-specific config,
    # see also flake.nix -> nixos-hardware modules
    ./hardware-configuration.nix

    inputs.self.nixosProfiles.desktop-gnome

    gnome-xrdp
    tailscale
    avahi
    plymouth
    dev
    spotify
    qflipper
    keybase
    messaging
    torrent
    chrome
    minecraft
    krita
    streaming
    vlc
    steam-run
    docker
  ];

  networking = {
    hostName = "celebi";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  system.stateVersion = "20.09";
  home-manager.users.vitalya.home.stateVersion = "20.09";
}
