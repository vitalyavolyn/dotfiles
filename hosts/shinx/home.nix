{ pkgs, lib, inputs, stateVersion, ... }:

{
  home = {
    inherit stateVersion;

    packages = with pkgs; [
      # system utilities
      pfetch
      p7zip
      neofetch
      file
      htop
      ranger
      nodejs_latest
      yarn
      docker-compose
    ];
  };
}
