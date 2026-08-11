{ den, ... }:

{
  den.aspects.desktop-gnome.includes = with den.aspects; [
    desktop
    gnome
    pipewire
  ];
}
