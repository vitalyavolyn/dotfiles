{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    boot
    nix
    locale
  ];
}
