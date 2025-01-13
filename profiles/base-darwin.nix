{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [
    base-home
    base-packages
    zsh
    user
    nix
    darwin # general tweaks
    brew
    fonts
  ] ++ (with inputs; [
    nix-homebrew.darwinModules.nix-homebrew
    home-manager.darwinModules.home-manager
    nix-index-database.darwinModules.nix-index
    agenix.nixosModules.default

    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    }
  ]);

  services.nix-daemon.enable = true;

  environment.variables.FLAKE = "/Users/vitalya/dotfiles";
}
