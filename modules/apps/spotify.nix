{ pkgs, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in
{
  home-manager.users.vitalya.programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.Default;
    colorScheme = "flamingo";

    enabledExtensions = with spicePkgs.extensions; [ popupLyrics ];
  };
}
