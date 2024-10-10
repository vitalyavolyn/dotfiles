{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    base-home
    base-packages
    zsh
    user
    # nix
    darwin # general tweaks
    brew
    # TODO:
    # ssh server?
    fonts
  ];

  # FIXME: nix module is not working
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      interval = { Weekday = 0; Hour = 0; Minute = 0; };
    };
    settings = {
      trusted-users = [ "root" "vitalya" ];
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  nixpkgs.config.allowUnfree = true;

  services.nix-daemon.enable = true;

  environment.variables.FLAKE = "/Users/vitalya/dotfiles";
}
