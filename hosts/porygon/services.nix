{ pkgs, config, ... }:

{
  imports = [
    ./services/shadowsocks.nix
    ./services/aof6.nix
  ];

  services.avahi.enable = false;
  services.tailscale.enable = false;
}
