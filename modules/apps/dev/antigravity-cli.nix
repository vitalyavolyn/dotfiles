{ ... }:

{
  den.aspects.antigravity-cli.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.antigravity-cli ];
  };
}
