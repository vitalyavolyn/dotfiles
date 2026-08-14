{ den, ... }:

{
  den.aspects.dev = {
    includes = with den.aspects; [ dev-db zed claude-code ];
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ gnumake nixf ];
    };
  };
}
