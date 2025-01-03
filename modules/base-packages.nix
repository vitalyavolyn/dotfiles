{ pkgs, ... }:

{
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

  programs.nix-index-database.comma.enable = true;
}
