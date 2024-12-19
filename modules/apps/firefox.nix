{ pkgs, lib, ... }:
with lib;
{
  home-manager.users.vitalya.programs.firefox = mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
    package = pkgs.firefox;
  };

  homebrew.casks = mkIf pkgs.stdenv.isDarwin [ "firefox" ];
}
