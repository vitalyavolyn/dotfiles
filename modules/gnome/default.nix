{ pkgs, ... }:

{
  imports = [
    ./dconf.nix
    ./gtk.nix
  ];

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ] ++ (with pkgs.gnomeExtensions; [
    appindicator
    screen-rotate
  ]);

  services.udev.packages = with pkgs; [
    gnome-settings-daemon
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-terminal
    epiphany
    geary
    evince
    gnome-connections
    gnome-music
  ];

  # disable screenshot sound
  home-manager.users.vitalya.xdg.dataFile = {
    "sounds/__custom/screen-capture.disabled".text = "";
  };
}
