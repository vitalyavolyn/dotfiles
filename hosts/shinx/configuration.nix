{ config, pkgs, inputs, ... }:

{
  imports =
    [
      # hardware-specific config,
      # see also flake.nix -> nixos-hardware modules
      ./hardware-configuration.nix

      ./general.nix
      ./services.nix
    ];
}
