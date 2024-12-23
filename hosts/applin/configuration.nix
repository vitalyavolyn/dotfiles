{ pkgs, inputs, ... }: {
  imports = with inputs.self.nixosModules; [
    inputs.self.nixosProfiles.base-darwin

    dev
    tailscale
    torrent
    firefox
    chrome
    vlc
    streaming
    minecraft
    messaging
    spotify
    qflipper

    # hammerspoon
  ];

  homebrew = {
    casks = [
      "microsoft-teams"
      "tunnelblick"
      "steam"
      "chatgpt"
      "jellyfin-media-player"
      "ticktick"
      "bitwarden"
    ];

    brews = [
    ];
  };

  home-manager.users.vitalya.home.packages = with pkgs; [
    jdk17
  ];

  home-manager.users.vitalya.home.file.".jdk/openjdk21".source = pkgs.jdk;

  home-manager.users.vitalya.home.stateVersion = "24.05";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
