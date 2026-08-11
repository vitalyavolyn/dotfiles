{ ... }:

{
  den.aspects.tailscale = {
    nixos = { config, ... }: {
      services.tailscale = {
        enable = true;
        extraSetFlags = [ "--operator=vitalya" ];
      };
      networking = {
        firewall.trustedInterfaces = [ "tailscale0" ];
        firewall.allowedUDPPorts = [ config.services.tailscale.port ];
      };
    };

    darwin.homebrew.casks = [ "tailscale" ];
  };
}
