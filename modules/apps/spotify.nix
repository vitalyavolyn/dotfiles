{ inputs, ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.spotify = mkApp {
    darwinCasks = [ "spotify" ];
    nixosHome = { pkgs, ... }:
      let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in {
        imports = [ inputs.spicetify-nix.homeManagerModules.default ];

        programs.spicetify = {
          enable = true;
          theme = spicePkgs.themes.default;
          enabledExtensions = [ spicePkgs.extensions.popupLyrics ];
        };
      };
  };
}
