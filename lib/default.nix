{ lib }:

{
  homelab = import ./homelab.nix { inherit lib; };
}
