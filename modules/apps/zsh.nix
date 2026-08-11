{ den, ... }:

{
  den.aspects.zsh = { host, ... }: {
    os.programs.zsh.enable = true;

    homeManager = { lib, pkgs, ... }:
      let
        hasDesktop = host.hasAspect den.aspects.desktop;
      in
      {
        home.packages = lib.optionals hasDesktop [ pkgs.wl-clipboard ];

        programs.zsh = {
          enable = true;
          autocd = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          history.ignoreDups = true;
          shellAliases = {
            l = "ls";
            la = "ls -a";
            p = "nix-shell --run zsh -p";
            nbs = lib.mkDefault "nh os switch";
          } // lib.optionalAttrs (host.class == "darwin" || hasDesktop) {
            x = if host.class == "darwin" then "pbcopy" else "wl-copy";
          };
          localVariables.REPORTTIME = 10;
          plugins = [{
            name = "zsh-nix-shell";
            file = "share/zsh/plugins/zsh-nix-shell/nix-shell.plugin.zsh";
            src = pkgs.zsh-nix-shell;
          }];
          oh-my-zsh = {
            enable = true;
            plugins = [ "git" "sudo" "dotenv" "yarn" "docker-compose" "history" ];
            theme = "fishy";
          };
        };
        programs.fzf = {
          enable = true;
          enableZshIntegration = true;
        };
        home.sessionPath = [ "$HOME/bin" "$HOME/.pub-cache/bin" "$HOME/.yarn/bin" ];
      };
  };
}
