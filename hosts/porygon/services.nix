{ pkgs, config, ... }:

{
  imports = [
    ./services/shadowsocks.nix
    ./services/aof6.nix
  ];

  networking.firewall = {
    allowedTCPPorts = [ config.services.shadowsocks.port ];
    allowedUDPPorts = [ config.services.shadowsocks.port ];
  };

  services.avahi.enable = false;
  services.tailscale.enable = false;
}
