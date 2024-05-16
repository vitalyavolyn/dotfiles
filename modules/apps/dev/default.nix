{ pkgs, ... }:

{
  imports = [
    ./db.nix
    ./golang.nix
    ./insomnia.nix
    ./vscode
  ];

  home-manager.users.vitalya.home.packages = with pkgs; [
    gnumake
    nixd
  ];
}
