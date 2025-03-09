{ pkgs, lib, options, ... }:
with lib;
{
  imports = [
    ./vscode
    ./insomnia.nix
    ./db.nix
  ];

  home-manager.users.vitalya.home.packages = with pkgs; [
    gnumake
    nixd
  ];
}
