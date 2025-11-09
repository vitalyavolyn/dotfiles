{ lib, config, pkgs, ... }:

{
  services.tailscale = {
    enable = true;
    # TODO: what if i change username?
    extraSetFlags = lib.optionals pkgs.stdenv.isLinux [ "--operator=vitalya" ];
  };

  networking =
    if pkgs.stdenv.isLinux then {
      firewall.trustedInterfaces = [ "tailscale0" ];
      firewall.allowedUDPPorts = [ config.services.tailscale.port ];
    } else { };
}
