{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    ./base-linux.nix

    kitty
    fonts
  ];
}
