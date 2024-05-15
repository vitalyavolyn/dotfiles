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
  ./apps/kitty.nix
  ./apps/vscode
  ./avahi.nix
  ./base-home.nix
  ./base-packages.nix
  ./boot.nix
  ./docker.nix
  ./fonts.nix
  ./gnome
  ./locale.nix
  ./nix.nix
  ./pulseaudio.nix
  ./ssh-server.nix
  ./tailscale.nix
  ./user.nix
  ./zsh.nix
])
