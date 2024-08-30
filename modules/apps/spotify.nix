{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  home-manager.users.vitalya.imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home-manager.users.vitalya.programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.default;
    colorScheme = "flamingo";

    enabledExtensions = with spicePkgs.extensions; [ popupLyrics ];
  };
}
