{ ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.obsidian = mkApp {
    darwinCasks = [ "obsidian" ];
    nixosHomePackages = pkgs: [ pkgs.obsidian ];
  };
}
