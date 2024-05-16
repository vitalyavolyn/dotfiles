{
  base = import ./base.nix;
  desktop-gnome = import ./desktop-gnome.nix;
  desktop = import ./desktop.nix;
  home = import ./home.nix;
}
