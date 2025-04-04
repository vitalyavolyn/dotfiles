{ ... }:

{
  services.tailscale = {
    extraUpFlags = [
      "--advertise-exit-node"
    ];
    extraSetFlags = [
      "--advertise-exit-node"
    ];
    useRoutingFeatures = "both";
  };
}
