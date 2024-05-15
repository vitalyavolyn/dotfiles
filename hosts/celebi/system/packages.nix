{ pkgs, inputs, ... }:

{
  nixpkgs.config = import ../nixpkgs-config.nix;

  environment.systemPackages = with pkgs; [
    pamixer
    pulseaudio

    intel-gpu-tools
  ];
  environment.variables.TERMINAL = "kitty";

  programs.light.enable = true;
}
