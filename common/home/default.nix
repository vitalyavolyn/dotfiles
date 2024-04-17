{ pkgs, version, ... }:

{
  imports = [
    ./zsh.nix
  ];

  home.file = {
    ".gitconfig".source = ./configs/gitconfig;
  };

  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  manual.manpages.enable = false;
}