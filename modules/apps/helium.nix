{ pkgs, inputs, lib, options, ... }:
with lib;
{
  config = mkMerge [
    (if (inputs.self.lib.isDarwin options) then {
      homebrew.casks = [ "helium-browser" ];
    } else {
      home-manager.users.vitalya.home.packages = [
        inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    })
  ];
}
