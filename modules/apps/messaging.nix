{ pkgs, lib, ... }:

with lib;
{
  home-manager.users.vitalya.home.packages = mkIf (!pkgs.stdenv.isDarwin)
    (with pkgs; [
      (discord.override {
        withOpenASAR = true;
      })
      tdesktop
    ]);

  homebrew.casks = mkIf pkgs.stdenv.isDarwin [
    "discord"
    "telegram"
  ];
}
