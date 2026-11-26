{ ... }:

{
  den.aspects.modrinth = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [
        (pkgs.symlinkJoin {
          name = "modrinth-app";
          paths = [ pkgs.modrinth-app ];
          # upstream link handler broken
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
