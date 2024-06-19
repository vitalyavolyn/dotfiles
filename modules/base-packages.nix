{ pkgs, ... }:

{
  # TODO: maybe split this file
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    speedtest-cli
    htop
    dnsutils
    tree
    gnupg
  ];

  environment.variables.EDITOR = "vim";

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
