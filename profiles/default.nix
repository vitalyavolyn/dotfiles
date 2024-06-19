{
  base = import ./base.nix;
  base-darwin = import ./base-darwin.nix;
  desktop-gnome = import ./desktop-gnome.nix;
  desktop-budgie = import ./desktop-budgie.nix;
  desktop = import ./desktop.nix;
}
