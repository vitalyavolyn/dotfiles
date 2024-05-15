{ pkgs, inputs, ... }:

{
  nixpkgs.config = import ../nixpkgs-config.nix;

  environment.systemPackages = with pkgs; [
    pamixer
    pulseaudio

    intel-gpu-tools

    mate.mate-polkit # TODO: exec on startup
  ];
  environment.variables.TERMINAL = "kitty";

  programs.light.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      # TODO: not working, add some kind of archive manager
      thunar-archive-plugin
      thunar-volman
    ];
  };
  programs.xfconf.enable = true;

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
}
  