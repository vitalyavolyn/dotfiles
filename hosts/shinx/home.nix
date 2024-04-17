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

    file = {
      # TODO: common
      ".gitconfig".source = ../celebi/home/configs/gitconfig;
    };
  };

  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  manual.manpages.enable = false;
}
