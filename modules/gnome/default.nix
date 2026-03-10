{ lib, config, pkgs, ... }:

let
  hasModule = name: builtins.hasAttr name config.modules;
  optionals = lib.optionals;
in
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
    wiggle
    bluetooth-battery-meter
    search-light
    window-is-ready-remover
    pip-on-top
  ]) ++ optionals (hasModule "tailscale") [
    pkgs.gnomeExtensions.tailscale-qs
  ];

  services.udev.packages = with pkgs; [
    gnome-settings-daemon
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-terminal
    epiphany
    evince
    gnome-connections
    gnome-music
  ];

  # disable screenshot sound by replacing it with a silent OGG file
  home-manager.users.vitalya.xdg.dataFile = {
    "sounds/freedesktop/stereo/screen-capture.oga".source = pkgs.runCommand "silent.oga" { nativeBuildInputs = [ pkgs.sox ]; } ''
      sox -n -r 44100 -c 2 -t ogg $out trim 0.0 0.1
    '';
  };
}
