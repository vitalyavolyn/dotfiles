# stolen from vyorkin/nixos-config

builtins.listToAttrs (builtins.map
  (path: {
    name = builtins.head (
      let
        b = builtins.baseNameOf path;
        m = builtins.match "(.*)\\.nix" b;
      in
      if isNull m then [ b ] else m
    );
    value = import path;
  }) [
  ./boot.nix
  ./fonts.nix
  ./gnome
  ./kitty.nix
  ./locale.nix
  ./nix.nix
  ./pipewire.nix
  ./pulseaudio.nix
  ./sddm.nix
])
