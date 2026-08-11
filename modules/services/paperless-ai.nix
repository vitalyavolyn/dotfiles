{ inputs, ... }:

{
  den.aspects.paperless-ai.nixos = { ... }: {
    # TODO: env file
    virtualisation.oci-containers.containers."paperless-ai" = {
      autoStart = true;
      image = "docker.io/clusterzx/paperless-ai";
      volumes = [ "/mnt/media/paperless-ai:/app/data" ];
      ports = [ "0.0.0.0:${toString (inputs.self.lib.homelab.portFor "paperless-ai")}:3000" ];
      extraOptions = [
        "--hostname=paperless-ai"
        "--pull=newer"
      ];
    };
  };
}
