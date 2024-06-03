# partially stolen from vyorkin/nixos-config
{ lib, ... }:

builtins.listToAttrs (builtins.map
  (path: rec {
    name = builtins.head (
      let
        b = builtins.baseNameOf path;
        m = builtins.match "(.*)\\.nix" b;
      in
      if isNull m then [ b ] else m
    );
    value = {
      imports = [ path ];
      options.modules = {
        ${name}.enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to enable ${name}.";
        };
      };
    };
  }) [
  ./apps/browser.nix
  ./apps/dev
  ./apps/keybase.nix
  ./apps/kitty.nix
  ./apps/krita.nix
  ./apps/messaging.nix
  ./apps/minecraft.nix
  ./apps/qflipper.nix
  ./apps/spotify.nix
  ./apps/steam-run.nix
  ./apps/streaming.nix
  ./apps/torrent.nix
  ./apps/vlc.nix
  ./apps/zsh.nix
  ./base-home.nix
  ./base-packages.nix
  ./boot.nix
  ./fonts.nix
  ./gnome
  ./lightdm-budgie.nix
  ./locale.nix
  ./nix.nix
  ./plymouth.nix
  ./services/avahi.nix
  ./services/docker.nix
  ./services/home-assistant.nix
  ./services/homepage.nix
  ./services/media-server.nix
  ./services/minecraft-aof6.nix
  ./services/nginx.nix
  ./services/pipewire.nix
  ./services/podman-auto-prune.nix
  ./services/pulseaudio.nix
  ./services/shadowsocks.nix
  ./services/ssh-server.nix
  ./services/tailscale.nix
  ./user.nix
])
