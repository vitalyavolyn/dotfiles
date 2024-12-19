{ pkgs, lib, ... }:
with lib;
{
  home-manager.users.vitalya.home.packages = mkIf (!pkgs.stdenv.isDarwin)
    (with pkgs; [ obs-studio ]);

  homebrew.casks = mkIf pkgs.stdenv.isDarwin [ "obs" ];
}
