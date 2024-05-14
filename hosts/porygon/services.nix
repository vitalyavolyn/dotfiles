{ pkgs, ... }:

{
  services = {
    shadowsocks = {
      enable = true;
      port = 8390;
      passwordFile = "/etc/shadowsocks_key";
      extraConfig = {
        method = "aes-256-cfb";
      };
    };
  };
}
