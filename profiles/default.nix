{
  base = import ./base.nix;
  desktop-gnome = import ./desktop-gnome.nix;
  desktop-budgie = import ./desktop-budgie.nix;
  desktop = import ./desktop.nix;
  home = import ./home.nix;
}
