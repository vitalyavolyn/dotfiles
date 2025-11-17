# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  # TODO: fingerprint reader
  imports = with inputs.self.nixosModules; [
    # hardware-specific config,
    # see also flake.nix -> nixos-hardware modules
    ./hardware-configuration.nix
    ./asus-rog-stuff.nix

    inputs.self.nixosProfiles.desktop-gnome

    tailscale
    avahi
    # plymouth
    dev
    { modules.dev.enable-nix-ld = true; }

    spotify
    qflipper
    messaging
    torrent
    firefox
    chrome
    minecraft
    krita
    streaming
    vlc
    steam-run

    steam
    sunshine
  ];

  services.logind.lidSwitchExternalPower = "ignore";

  networking = {
    hostName = "tynamo";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  system.stateVersion = "25.05";
  home-manager.users.vitalya.home.stateVersion = "25.05";
}
