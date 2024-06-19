{ pkgs, inputs, ... }: {
  imports = with inputs.self.nixosModules; [
    inputs.self.nixosProfiles.base-darwin
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;

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

    casks = [
      "visual-studio-code"
      "telegram"
      "google-chrome"
      "microsoft-teams"
      "mongodb-compass"
      "tunnelblick"
    ];
  };

  users.users.vitalya.home = "/Users/vitalya";
  home-manager.users.vitalya.home.stateVersion = "24.05";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
