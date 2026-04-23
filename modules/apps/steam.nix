{ pkgs, lib, options, inputs, ... }:
with lib;
{
  config = mkMerge [
    (if (inputs.self.lib.isDarwin options) then {
      homebrew.casks = [ "steam" ];
    } else {
      programs.steam = {
        enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
    })
  ];
}
