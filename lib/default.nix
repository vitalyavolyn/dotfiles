{ lib }:

{
  homelab = import ./homelab.nix { inherit lib; };

  # True when running under nix-darwin
  isDarwin = options: builtins.hasAttr "homebrew" options;
}
