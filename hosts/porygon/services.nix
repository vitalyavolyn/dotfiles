{ pkgs, ... }:

{
  imports = [
    ./services/shadowsocks.nix
    ./services/aof6.nix
  ];
}
