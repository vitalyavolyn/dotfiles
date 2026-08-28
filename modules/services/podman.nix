{ ... }:

{
  den.aspects.podman.nixos = { ... }: {
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };

    virtualisation.oci-containers.backend = "podman";

    # Host resolv.conf points at Tailscale's MagicDNS proxy (100.100.100.100),
    # which is only reachable from the host's own interfaces — not from
    # containers on the podman bridge via NAT. Without this, external DNS
    # inside any bridge-networked container just times out.
    virtualisation.containers.containersConf.settings.containers.dns_servers = [
      "1.1.1.1"
      "9.9.9.9"
    ];

    # Containers that need to reach back into the host (e.g. a CI job
    # container hitting forgejo-runner's actions-cache server on the LAN
    # IP) otherwise get silently dropped by nixos-fw once firewall.enable
    # is on — netavark's own chain only opens DNS. Per-job podman networks
    # get a fresh bridge each time (podman3, podman4, ...), so trust by
    # source range rather than interface name: 10.88.0.0/16 is the default
    # bridge, 10.89.0.0/16 the pool netavark carves per-network /24s from.
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p tcp -s 10.88.0.0/16 -j nixos-fw-accept
      iptables -A nixos-fw -p tcp -s 10.89.0.0/16 -j nixos-fw-accept
    '';
  };
}
