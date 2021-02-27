{ pkgs, ... }:

{
  imports = [ <home-manager/nixos> ];

  users.users.vitalya = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  home-manager.users.vitalya = {
    home.packages = with pkgs; [
      neofetch
      nixpkgs-fmt
      google-chrome
      discord
      vk-messenger
      tdesktop
      p7zip
    ];

    home.file = {
      ".ssh/config".source = ./configs/ssh-config;
      ".gitconfig".source = ./configs/gitconfig;
    };

    xdg.configFile = {
      "nixpkgs/config.nix".source = ../nixpkgs-config.nix;
      "Code/User/settings.json".source = ./configs/vscode.json;
    };

    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
      };

      vscode = with pkgs; {
        enable = true;
        package = vscode;
        extensions = with vscode-extensions; [
          jnoortheen.nix-ide
          eamodio.gitlens
          ms-vscode-remote.remote-ssh
        ] ++ vscode-utils.extensionsFromVscodeMarketplace [{
          name = "vscode-theme-onedark";
          publisher = "akamud";
          version = "2.2.3";
          sha256 = "1m6f6p7x8vshhb03ml7sra3v01a7i2p3064mvza800af7cyj3w5m";
        }];
      };
    };

    gtk = {
      enable = true;
      theme = {
        package = pkgs.arc-theme;
        name = "Arc-Dark";
      };
    };
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  security.sudo.wheelNeedsPassword = false;
}
