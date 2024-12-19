{ pkgs, lib, options, ... }:
with lib;
{
  config = mkMerge [
    (if (builtins.hasAttr "homebrew" options) then {
      homebrew.casks = [ "firefox" ];
    } else {
      home-manager.users.vitalya.programs.firefox = {
        enable = true;
        package = pkgs.firefox;
      };
    })
  ];
}
