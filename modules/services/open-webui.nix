{ ... }:

{
  virtualisation.oci-containers.containers.OpenWebUI = {
    image = "ghcr.io/open-webui/open-webui:main";
    autoStart = true;
    ports = [ "3100:8080" ];

    environment = {
      LOG_LEVEL = "info";
      LOG_HTML = "false";
      OLLAMA_BASE_URL = "http://ollama.local:11434";
    };

    extraOptions = [
      "--pull=newer"
      "--add-host=ollama.local:100.70.91.98"
    ];

    volumes = [ "open-webui:/app/backend/data" ];
  };
}
