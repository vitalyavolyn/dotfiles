{ ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.torrent = mkApp {
    darwinCasks = [ "qbittorrent" ];
    nixosHomePackages = pkgs: [ pkgs.qbittorrent ];
  };
}
