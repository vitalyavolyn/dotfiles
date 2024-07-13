{ pkgs, lib, ... }:

{
  imports = [
    ./golang.nix
    ./vscode
    # TODO: fix
  ]; # ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
  #  ./db.nix
  #  ./insomnia.nix
  #];

  home-manager.users.vitalya.home.packages = with pkgs; [
    gnumake
    nixd

    zig
    zls
  ];
}
