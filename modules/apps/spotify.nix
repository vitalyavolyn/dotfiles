{ pkgs
, lib
, inputs
, options
, ...
}:
with lib;
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  config = mkMerge [
    (
      if (builtins.hasAttr "homebrew" options) then
        {
          homebrew.casks = [ "spotify" ];
        }
      else
        {
          home-manager.users.vitalya = {
            imports = [
              inputs.spicetify-nix.homeManagerModules.default
            ];

            programs.spicetify = {
              enable = true;
              theme = spicePkgs.themes.default;
              # colorScheme = "flamingo";
              enabledExtensions = with spicePkgs.extensions; [ popupLyrics ];
            };
          };
        }
    )
  ];
}
