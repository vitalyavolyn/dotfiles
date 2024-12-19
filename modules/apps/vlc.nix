{ pkgs, lib, ... }:

with lib;
{
  home-manager.users.vitalya.home.packages = mkIf (!pkgs.stdenv.isDarwin)
    (with pkgs; [ vlc ]);

  homebrew.casks = mkIf pkgs.stdenv.isDarwin [ "vlc" ];
}
