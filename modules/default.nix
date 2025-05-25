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
  ./apps/chrome.nix
  ./apps/dev
  ./apps/firefox.nix
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
  ./darwin
  ./darwin/brew.nix
  ./fonts.nix
  ./gnome
  ./lightdm-budgie.nix
  ./locale.nix
  ./nix.nix
  ./plymouth.nix
  ./services/adguard-home.nix
  ./services/avahi.nix
  ./services/caddy.nix
  ./services/docker.nix
  ./services/fail2ban.nix
  ./services/gnome-xrdp.nix
  ./services/home-assistant
  ./services/homepage.nix
  ./services/media-server.nix
  ./services/minecraft-atm10-2.nix
  ./services/minecraft-atm10.nix
  ./services/minecraft-atm9.nix
  ./services/minecraft-mzhip.nix
  ./services/miniflux.nix
  ./services/n8n.nix
  ./services/nginx.nix
  ./services/pipewire.nix
  ./services/podman-auto-prune.nix
  ./services/shadowsocks.nix
  ./services/ssh-server.nix
  ./services/tailscale-exit-node.nix
  ./services/tailscale.nix
  ./user.nix
])
