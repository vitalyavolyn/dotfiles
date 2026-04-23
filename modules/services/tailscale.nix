{ config, options, inputs, ... }:

{
  config =
    if (inputs.self.lib.isDarwin options) then {
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
