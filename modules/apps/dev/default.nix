{ pkgs, lib, ... }:
with lib;
{
  imports = [
    ./vscode
    ./db.nix
  ];

  home-manager.users.vitalya.home.packages = with pkgs; [
    gnumake
    nixd
    nil
    zed-editor
  ];
}
