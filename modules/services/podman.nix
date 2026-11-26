{ ... }:

{
  den.aspects.podman.nixos = { ... }: {
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };

    virtualisation.oci-containers.backend = "podman";

    # force non tailscale dns for it to work at all
    virtualisation.containers.containersConf.settings.containers.dns_servers = [
      "1.1.1.1"
      "9.9.9.9"
    ];

    # i hate networking
    networking.firewall.extraCommands = ''
      iptables -A nixos-fw -p tcp -s 10.88.0.0/16 -j nixos-fw-accept
      iptables -A nixos-fw -p tcp -s 10.89.0.0/16 -j nixos-fw-accept
    '';
  };
}
