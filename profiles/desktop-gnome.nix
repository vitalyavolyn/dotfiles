{ inputs, ... }: {
  imports = with inputs.self.nixosModules; [
    ./desktop.nix

    gnome
    pipewire
  ];
}
