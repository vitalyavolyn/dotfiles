{ config, ... }:

{
  services = {
    n8n = {
      enable = true;
      openFirewall = true;
      settings = {
        secure_cookie = false;
      };
    };
  };
}
