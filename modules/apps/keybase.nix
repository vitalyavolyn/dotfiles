{ ... }:

{
  den.aspects.keybase.nixos = {
    services = {
      keybase.enable = true;
      kbfs.enable = true;
    };
  };
}
