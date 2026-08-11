{ inputs, ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.helium = mkApp {
    darwinCasks = [ "helium-browser" ];
    nixosHomePackages = pkgs: [ inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
