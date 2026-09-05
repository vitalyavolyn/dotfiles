{ inputs, ... }:

{
  den.aspects.genshin.nixos = { ... }: {
    imports = [ inputs.aagl.nixosModules.default ];
    programs.anime-game-launcher.enable = true;
  };
}
