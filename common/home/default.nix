{ pkgs, version, ... }:

{
  imports = [
    ./zsh.nix
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    #dev stuff
    httpie

    # system utilities
    nixpkgs-fmt
    p7zip
    neofetch
    file
    htop
    ranger

    # dev tools
    nodejs_latest
    yarn
    docker-compose
    httpie
  ];

  home.file = {
    ".gitconfig".source = ./configs/gitconfig;
  };

  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  manual.manpages.enable = false;

  programs = {
    ranger = {
      enable = true;
      settings = {
        preview_images = true;
        preview_images_method = "kitty";
      };
    };
  };
}
