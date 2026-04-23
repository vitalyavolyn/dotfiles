{ pkgs, lib, options, inputs, ... }:
with lib;
{
  config = mkMerge [
    (if (inputs.self.lib.isDarwin options) then {
      homebrew.casks = [ "firefox" ];
    } else {
      home-manager.users.vitalya.programs.firefox = {
        enable = true;
        package = pkgs.firefox;
      };
    })
  ];
}
