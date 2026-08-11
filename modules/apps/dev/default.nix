{ den, ... }:

{
  den.aspects.dev = {
    includes = with den.aspects; [ dev-db zed ];
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ gnumake nixf claude-code ];
    };
  };
}
