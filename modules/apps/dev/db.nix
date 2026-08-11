{ ... }:

let mkApp = import ../_mk-app.nix;
in
{
  den.aspects.dev-db = mkApp {
    darwinCasks = [ "mongodb-compass" "dbeaver-community" ];
    nixosHomePackages = pkgs: [ pkgs.dbeaver-bin ];
  };
}
