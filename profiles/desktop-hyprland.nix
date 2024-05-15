{ inputs, ... }: {
  imports = with inputs.self.nixosModules; [
    ./desktop.nix

    sddm
    hyprland
    pipewire
  ];
}
