{ pkgs, ... }:

{
  nixpkgs.config = import ../nixpkgs-config.nix;

  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    kitty
    xclip

    xfce.xfce4-power-manager
    xfce.xfce4-panel
    xfce.xfce4-i3-workspaces-plugin
    xfce.xfce4-xkb-plugin
    xfce.xfce4-pulseaudio-plugin
  ];
  environment.variables.TERMINAL = "kitty";

  programs.zsh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
