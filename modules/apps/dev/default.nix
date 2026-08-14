{ den, ... }:

{
  den.aspects.dev = {
    includes = with den.aspects; [ dev-db zed claude-code codex-cli ];
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ gnumake nixf ];
    };
  };
}
