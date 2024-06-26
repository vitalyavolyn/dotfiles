{ pkgs, inputs, ... }: {
  imports = with inputs.self.nixosModules; [
    inputs.self.nixosProfiles.base-darwin

    dev
    tailscale
  ];

  nixpkgs.config.allowUnfree = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.settings.experimental-features = "nix-command flakes";

  nix-homebrew = {
    enable = true;

    user = "vitalya";

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };

    mutableTaps = false;
  };

  homebrew = {
    enable = true;

    onActivation.cleanup = "uninstall";

    casks = [
      "telegram"
      "google-chrome"
      "microsoft-teams"
      "mongodb-compass"
      "tunnelblick"
      "steam"
      "spotify"
      "chatgpt"
      "clickup"
      "prismlauncher" # prismlauncher via nix no buildy :(
      "discord"
      "jellyfin-media-player"
      "ticktick"
    ];
  };

  home-manager.users.vitalya.home.packages = with pkgs; [
    jdk17
  ];

  security.pam.enableSudoTouchIdAuth = true;

  users.users.vitalya.home = "/Users/vitalya";
  home-manager.users.vitalya.home.stateVersion = "24.05";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
