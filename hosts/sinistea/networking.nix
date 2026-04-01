{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "8.8.8.8" ];
    defaultGateway = "10.0.0.1";
    defaultGateway6 = {
      address = "2a12:bec4:1bb0:104f::1";
      interface = "ens3";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce true;
    interfaces = {
      ens3 = {
        ipv4.addresses = [
          { address = "144.31.196.197"; prefixLength = 32; }
        ];
        ipv6.addresses = [
          { address = "2a12:bec4:1bb0:104f::2"; prefixLength = 64; }
          { address = "fe80::5054:ff:fe07:c84c"; prefixLength = 64; }
        ];
        ipv4.routes = [ { address = "10.0.0.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = "2a12:bec4:1bb0:104f::1"; prefixLength = 128; } ];
      };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="52:54:00:07:c8:4c", NAME="ens3"
  '';
}
