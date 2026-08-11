{ den, ... }:

{
  den.aspects.desktop = {
    includes = with den.aspects; [
      base-linux
      kitty
      avahi
      fonts
    ];

    nixos.boot.plymouth.enable = true;
  };
}
