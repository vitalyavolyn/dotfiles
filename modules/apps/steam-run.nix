{ ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.steam-run = mkApp {
    nixosHomePackages = pkgs: [ pkgs.steam-run ];
  };
}
