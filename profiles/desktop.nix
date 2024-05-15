{ pkgs, inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    ./base.nix

    kitty
    fonts
  ];
}
