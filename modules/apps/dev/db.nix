{ pkgs, lib, options, ... }:
with lib;
{
  config = mkMerge [
    (if (builtins.hasAttr "homebrew" options) then {
      homebrew.casks = [
        "mongodb-compass"
        "studio-3t"
        # "dbeaver-community" 
      ];
    } else {
      home-manager.users.vitalya.home.packages = with pkgs; [
        # dbeaver-bin
        mongodb-compass
        robo3t
      ];
    })
  ];
}
