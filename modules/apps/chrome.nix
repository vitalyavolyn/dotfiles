{ pkgs, lib, options, inputs, ... }:
with lib;
{
  config = mkMerge [
    (if (inputs.self.lib.isDarwin options) then {
      homebrew.casks = [ "google-chrome" ];
    } else {
      home-manager.users.vitalya.programs.chromium = {
        enable = true;
        package = pkgs.google-chrome;
      };
    })
  ];
}
