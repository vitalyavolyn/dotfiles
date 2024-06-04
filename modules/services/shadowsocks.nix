{ config, ... }:

{
  services = {
    shadowsocks = {
      enable = true;
      port = 8388;
      passwordFile = "/etc/shadowsocks_key";
      encryptionMethod = "aes-256-cfb";
      extraConfig = {
        local_port = 1080;
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ config.services.shadowsocks.port ];
    allowedUDPPorts = [ config.services.shadowsocks.port ];
  };
}
