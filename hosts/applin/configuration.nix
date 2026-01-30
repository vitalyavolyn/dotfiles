{ pkgs, inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    inputs.self.nixosProfiles.base-darwin

    dev
    tailscale
    firefox
    # chrome
    vlc
    streaming
    minecraft
    messaging
    spotify
    krita
    obsidian
    claude-desktop
    helium
  ];

  homebrew = {
    casks = [
      "microsoft-teams"
      "tunnelblick"
      "chatgpt"
      "ticktick"
      "bitwarden"
      "cyberduck"

      # TODO: cross platform logitech module with
      # https://github.com/pwr-Solaar/Solaar
      "logi-options+"
    ];

    brews = [
      "mole"
    ];
  };

  home-manager.users.vitalya.home.packages = with pkgs; [
    jdk
  ];

  system.stateVersion = 4;
  home-manager.users.vitalya.home.stateVersion = "24.05";

  nixpkgs.hostPlatform = "aarch64-darwin";
}
