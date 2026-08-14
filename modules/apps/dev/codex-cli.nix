{ ... }:

{
  den.aspects.codex-cli.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.codex ];
  };
}
