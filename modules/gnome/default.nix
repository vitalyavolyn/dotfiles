{ pkgs, ... }:

{
  imports = [
    ./dconf.nix
    ./gtk.nix
  ];

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.systemPackages = with pkgs.gnome; [
    gnome-tweaks

    pkgs.xwaylandvideobridge
  ] ++ (with pkgs.gnomeExtensions; [
    appindicator
  ]);

  services.udev.packages = with pkgs;
    [ gnome.gnome-settings-daemon ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
    gnome-connections
  ]) ++ (with pkgs.gnome; [
    gnome-music
    gnome-terminal
    epiphany
    geary
    evince
  ]);
}
