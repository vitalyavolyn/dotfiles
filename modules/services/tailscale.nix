{ config, pkgs, ... }:

{
  services.tailscale.enable = true;

  networking = if pkgs.stdenv.isLinux then {
    firewall.trustedInterfaces = [ "tailscale0" ];
    firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  } else {};
}
