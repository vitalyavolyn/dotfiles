{ ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.streaming = mkApp {
    darwinCasks = [ "obs" ];
    nixosHomePackages = pkgs: [ pkgs.obs-studio ];
  };
}
