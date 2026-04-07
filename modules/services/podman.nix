{ ... }:

{
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
  };

  virtualisation.oci-containers.backend = "podman";
}
