{ den, ... }:

{
  den.aspects.desktop = {
    includes = with den.aspects; [
      base-linux
      ghostty
      avahi
      fonts
    ];

    nixos.boot.plymouth.enable = true;
  };
}
