{ pkgs, lib, ... }:

with lib;
{
  imports = [
    ./vscode
    ./db.nix
    ./zed.nix
  ];

  home-manager.users.vitalya.home.packages = with pkgs; [
    gnumake
    nixd
  ];
}
