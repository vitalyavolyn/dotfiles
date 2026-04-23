{ pkgs, lib, options, inputs, ... }:
with lib;
{
  config = mkMerge [
    (if (inputs.self.lib.isDarwin options) then {
      homebrew.casks = [ "obsidian" ];
    } else {
      home-manager.users.vitalya.home.packages = with pkgs; [ obsidian ];
    })
  ];
}
