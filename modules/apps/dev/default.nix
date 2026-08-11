{ pkgs, ... }:
{
  imports = [
    ./db.nix
    ./zed.nix
  ];

  home-manager.users.vitalya.home.packages = with pkgs; [
    gnumake
    nixd
    nixf
    claude-code
  ];
}
