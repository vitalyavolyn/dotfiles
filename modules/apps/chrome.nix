{ pkgs, lib, ... }:
with lib;
{
  home-manager.users.vitalya.programs.chromium = mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
    package = pkgs.google-chrome;
  };

  homebrew.casks = mkIf pkgs.stdenv.isDarwin [ "google-chrome" ];
}
