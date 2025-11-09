{ lib, config, pkgs, ... }:

{
  services.tailscale = if pkgs.stdenv.isLinux then {
    enable = true;
    extraSetFlags = [ "--operator=vitalya" ];
  } else {
    enable = true;
  };

  networking =
    if pkgs.stdenv.isLinux then {
      firewall.trustedInterfaces = [ "tailscale0" ];
      firewall.allowedUDPPorts = [ config.services.tailscale.port ];
    } else { };
}
