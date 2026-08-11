{ ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.krita = mkApp {
    darwinCasks = [ "krita" ];
    nixosHomePackages = pkgs: [ pkgs.krita ];
  };
}
