{ lib }:

{
  homelab = import ./homelab.nix { inherit lib; };

  isDarwin = options: builtins.hasAttr "homebrew" options;
}
