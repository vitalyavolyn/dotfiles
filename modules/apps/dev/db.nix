{ pkgs, lib, options, inputs, ... }:
with lib;
{
  config = mkMerge [
    (if (inputs.self.lib.isDarwin options) then {
      homebrew.casks = [
        "mongodb-compass"
        "dbeaver-community"
      ];
    } else {
      home-manager.users.vitalya.home.packages = with pkgs; [
        mongodb-compass
        dbeaver-bin
      ];
    })
  ];
}
