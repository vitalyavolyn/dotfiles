{ inputs, ... }:

{
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
  };
}
