{ ... }:

{
  den.aspects.podman.nixos = { ... }: {
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
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
  };
}
