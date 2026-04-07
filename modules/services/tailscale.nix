{ lib, config, options, ... }:

{
  config = if (builtins.hasAttr "homebrew" options) then {
    homebrew.casks = [ "tailscale" ];
  } else {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--operator=vitalya" ];
    };
    networking = {
      firewall.trustedInterfaces = [ "tailscale0" ];
      firewall.allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };
}
