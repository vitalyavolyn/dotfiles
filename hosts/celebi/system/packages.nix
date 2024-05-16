{ pkgs, ... }:

{
  nixpkgs.config = import ../nixpkgs-config.nix;

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
  ];
}
