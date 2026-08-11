{ ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.chrome = mkApp {
    darwinCasks = [ "google-chrome" ];
    nixosHomePackages = pkgs: [ pkgs.google-chrome ];
  };
}
