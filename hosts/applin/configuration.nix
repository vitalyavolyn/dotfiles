{ pkgs, inputs, ... }: {
  imports = with inputs.self.nixosModules; [
    inputs.self.nixosProfiles.base-darwin

    dev
    tailscale
    torrent

    hammerspoon
  ];

  homebrew = {
    casks = [
      "telegram"
      "google-chrome"
      "microsoft-teams"
      "mongodb-compass"
      "tunnelblick"
      "steam"
      "spotify"
      "chatgpt"
      "prismlauncher" # prismlauncher via nix no buildy :(
      "discord"
      "jellyfin-media-player"
      "ticktick"
      "obs"
      "vlc"
      "qflipper"
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
