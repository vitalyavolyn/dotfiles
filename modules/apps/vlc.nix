{ ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.vlc = mkApp {
    darwinCasks = [ "vlc" ];
    nixosHomePackages = pkgs: [ pkgs.vlc ];
  };
}
