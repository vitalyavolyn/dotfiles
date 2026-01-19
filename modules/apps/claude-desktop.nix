{ pkgs, inputs, ... }:

{
  # linux only
  home-manager.users.vitalya.home.packages = [
    inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop-with-fhs
  ];
}
