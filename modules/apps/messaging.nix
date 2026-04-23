{ pkgs, lib, options, inputs, ... }:
with lib;
{
  config = mkMerge [
    (if (inputs.self.lib.isDarwin options) then {
      homebrew.casks = [
        "discord"
        "telegram"
      ];
    } else {
      home-manager.users.vitalya.home.packages = with pkgs; [
        # (discord.override {
        #   withOpenASAR = true;
        # })
        discord
        telegram-desktop
      ];
    })
  ];
}
