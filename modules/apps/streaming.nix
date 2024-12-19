{ pkgs, lib, options, ... }:
with lib;
{
  config = mkMerge [
    (if (builtins.hasAttr "homebrew" options) then {
      homebrew.casks = [ "obs" ];
    } else {
      home-manager.users.vitalya.home.packages = with pkgs; [ obs-studio ];
    })
  ];
}
