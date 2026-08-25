{ ... }:

{
  den.aspects.ghostty = {
    os.environment.variables.TERMINAL = "ghostty";

    darwin.homebrew.casks = [ "ghostty" ];

    homeManager = { pkgs, ... }: {
      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;
        settings = {
          font-family = "Fira Code";
          theme = "Afterglow";
        };
        enableZshIntegration = true;
      };
    };
  };
}
