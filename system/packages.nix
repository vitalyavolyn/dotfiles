{ pkgs, inputs, ... }:

{
  nixpkgs.config = import ../nixpkgs-config.nix;

  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    kitty

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

  programs.light.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}
