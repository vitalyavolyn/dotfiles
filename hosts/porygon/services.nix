{ pkgs, ... }:

{
  imports = [
    ./services/shadowsocks.nix
  ];
}