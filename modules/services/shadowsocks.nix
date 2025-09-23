{ config, pkgs, ... }:

{
  services = {
    shadowsocks = {
      enable = true;
      localAddress = "0.0.0.0";
      port = 8388;
      plugin = "${pkgs.shadowsocks-v2ray-plugin}/bin/v2ray-plugin";
      pluginOpts = "server";
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
