{ inputs, ... }: {
  imports = with inputs.self.nixosModules; [
    ./desktop.nix

    lightdm-budgie
    pipewire
  ];
}
