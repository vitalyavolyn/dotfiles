{ pkgs, lib, options, ... }:
with lib;
{
  config = mkMerge [
    (if (builtins.hasAttr "homebrew" options) then {
      homebrew.casks = [
        "discord"
        "telegram"
      ];
    } else {
      home-manager.users.vitalya.home.packages = with pkgs; [
        (discord.override {
          withOpenASAR = true;
        })
        telegram-desktop
      ];
    })
  ];
}
