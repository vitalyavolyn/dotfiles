{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    ./base-linux.nix

    kitty
    avahi
    fonts
  ];

  boot.plymouth.enable = true;
}
