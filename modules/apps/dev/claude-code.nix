{ ... }:

{
  den.aspects.claude-code.homeManager = { pkgs, ... }: {
    home.packages = [ pkgs.claude-code ];
  };
}
