{ pkgs, lib, options, ... }:
with lib;
{
  config = mkMerge [
    (if (builtins.hasAttr "homebrew" options) then {
      homebrew.casks = [ "google-chrome" ];
    } else {
      home-manager.users.vitalya.programs.chromium = {
        enable = true;
        package = pkgs.google-chrome;
      };
    })
  ];
}
