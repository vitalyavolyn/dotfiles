{ lib, options, inputs, ... }:
with lib;
{
  config = mkMerge [
    (if (inputs.self.lib.isDarwin options) then {
      homebrew.casks = [ "claude" ];
    } else {
      # broken: nodePackages.asar was removed from nixpkgs (2026-03-03)
      warnings = [ "claude-desktop module is broken on Linux, skipping" ];
    })
  ];
}
