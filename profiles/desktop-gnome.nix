{ inputs, ... }: {
  imports = with inputs.self.nixosModules; [
    ./desktop.nix

    gnome
    pulseaudio
  ];
}
