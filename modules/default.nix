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
  ./apps/keybase.nix
  ./apps/kitty.nix
  ./apps/messaging.nix
  ./apps/qflipper.nix
  ./apps/spotify.nix
  ./apps/vscode
  ./apps/zsh.nix
  ./base-home.nix
  ./base-packages.nix
  ./boot.nix
  ./fonts.nix
  ./gnome
  ./locale.nix
  ./nix.nix
  ./plymouth.nix
  ./pulseaudio.nix
  ./services/avahi.nix
  ./services/docker.nix
  ./services/homepage.nix
  ./services/media-server.nix
  ./services/shadowsocks.nix
  ./services/ssh-server.nix
  ./services/minecraft-aof6.nix
  ./services/tailscale.nix
  ./user.nix
])
