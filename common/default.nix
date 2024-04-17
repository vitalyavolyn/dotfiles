{ pkgs, version, ... }:

{
  imports = [
    ./general.nix
    ./packages.nix
    ./services.nix
    ./nix.nix
    ./users.nix
  ];
}