{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    # hardware-specific config,
    # see also flake.nix -> nixos-hardware modules
    ./hardware-configuration.nix

    inputs.self.nixosProfiles.desktop-gnome

    tailscale
    avahi
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
    # steam-run
    docker
  ];

  networking = {
    hostName = "celebi";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  nixpkgs.config = import ./nixpkgs-config.nix;

  system.stateVersion = "20.09";

  services.udev.extraRules = ''
    # Temporarily disable internal keyboard
    KERNELS=="input1",ATTRS{id/bustype}=="0011",ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';
}
