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

  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ] ++ (with pkgs.gnomeExtensions; [
    appindicator
  ]);

  services.udev.packages = with pkgs;
    [ gnome.gnome-settings-daemon ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
    gnome-terminal
    epiphany
    geary
    evince   gnome-connections
  ]) ++ (with pkgs.gnome; [
    gnome-music
  ]);

  # disable screenshot sound
  home-manager.users.vitalya.xdg.dataFile = {
    "sounds/__custom/screen-capture.disabled".text = "";
  };
}
