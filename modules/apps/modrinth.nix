# Upstream's .desktop file registers ModrinthApp as the
# x-scheme-handler/modrinth handler but its Exec line has no %u, so
# xdg-open never passes the modrinth:// invite/server link through -
# clicking "Accept invite" on modrinth.com just refocuses the app with
# nothing to act on. Patch the Exec line to forward the URL.
{ ... }:

{
  den.aspects.modrinth = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [
        (pkgs.symlinkJoin {
          name = "modrinth-app";
          paths = [ pkgs.modrinth-app ];
          postBuild = ''
            rm "$out/share/applications/Modrinth App.desktop"
            cp "${pkgs.modrinth-app}/share/applications/Modrinth App.desktop" \
              "$out/share/applications/Modrinth App.desktop"
            sed -i 's/^Exec=ModrinthApp$/Exec=ModrinthApp %u/' \
              "$out/share/applications/Modrinth App.desktop"
          '';
        })
      ];
    };
  };
}
