{ lib, options, ... }:
with lib;
{
  config = mkMerge [
    (if (builtins.hasAttr "homebrew" options) then {
      homebrew.casks = [ "claude" ];
    } else {
      # broken: nodePackages.asar was removed from nixpkgs (2026-03-03)
      warnings = [ "claude-desktop module is broken on Linux, skipping" ];
    })
  ];
}
