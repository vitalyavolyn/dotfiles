{ ... }:

{
  services.create_ap = {
    enable = true;
    settings = {
      INTERNET_IFACE = "eno1";
      WIFI_IFACE = "wlp1s0";
      SSID = "shinx";
      PASSPHRASE = "bulbasaur";
    };
  };
}
