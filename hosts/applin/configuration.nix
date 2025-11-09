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
    krita
    obsidian
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
      "libusb"
    ];
  };

  home-manager.users.vitalya.home.packages = with pkgs; [
    jdk
  ];

  home-manager.users.vitalya.home.stateVersion = "24.05";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
