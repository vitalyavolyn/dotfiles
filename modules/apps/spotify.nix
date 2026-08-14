{ inputs, ... }:

let
  mkApp = import ./_mk-app.nix;
  spicetifyHome = { pkgs, ... }:
    let spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      imports = [ inputs.spicetify-nix.homeManagerModules.default ];

      programs.spicetify = {
        enable = true;
        theme = spicePkgs.themes.default;
        enabledExtensions = with spicePkgs.extensions; [
          popupLyrics
          shuffle
          beautiful-lyrics
        ];
      };
    };
in
{
  den.aspects.spotify = mkApp {
    nixosHome = spicetifyHome;
    darwinHome = spicetifyHome;
  };
}
