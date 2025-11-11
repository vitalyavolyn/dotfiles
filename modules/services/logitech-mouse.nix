{ lib, pkgs, inputs, options, ... }:

{
  imports = [ inputs.solaar.nixosModules.default ];

  config = lib.mkMerge [
    (if (builtins.hasAttr "homebrew" options) then  {
      homebrew.casks = [ "logi-options+" ];
    } else {
      hardware.logitech.wireless.enable = true;
      hardware.logitech.wireless.enableGraphical = true;
      services.solaar.enable = true;
    })
  ];
}
