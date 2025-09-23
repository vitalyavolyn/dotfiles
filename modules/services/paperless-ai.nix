{ lib, config, ... }:

{
  config = {
    virtualisation.oci-containers.containers."paperless-ai" = {
      autoStart = true;
      image = "docker.io/clusterzx/paperless-ai";
      volumes = [ "/mnt/media/paperless-ai:/app/data" ];
      ports = [ "0.0.0.0:3000:3000" ];
      extraOptions = [
        "--hostname=paperless-ai"
        "--pull=newer"
      ];
    };

    # networking.firewall.allowedTCPPorts = [ 3000 ];
  };
}

