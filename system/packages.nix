{ pkgs, ... }:

{
  nixpkgs.config = import ../nixpkgs-config.nix;

  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    kitty

    xfce.xfce4-panel

    pamixer
    pulseaudio

    intel-gpu-tools
  ];
  environment.variables.TERMINAL = "kitty";

  programs.zsh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.kdeconnect.enable = true;

  programs.light.enable = true;
}
