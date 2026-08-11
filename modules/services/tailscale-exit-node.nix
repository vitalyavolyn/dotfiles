{ ... }:

{
  den.aspects.tailscale-exit-node.nixos = { ... }: {
    services.tailscale = {
      extraUpFlags = [
        "--advertise-exit-node"
      ];
      extraSetFlags = [
        "--advertise-exit-node"
      ];
      useRoutingFeatures = "both";
    };
  };
}
