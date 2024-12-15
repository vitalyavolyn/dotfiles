{ inputs, pkgs, ... }:

let nixneovim = inputs.nixneovim;
in
{
  nixpkgs.overlays = [
    nixneovim.overlays.default
  ];

  home-manager.users.vitalya = {
    imports = [ nixneovim.nixosModules.default ];
    programs.nixneovim = {
      enable = true;

      plugins = {
        lspconfig = {
          enable = true;
          servers = {
            nil.enable = true;
            typescript-language-server.enable = true;
          };
        };
        treesitter = {
          enable = true;
          indent = true;
        };
        mini = {
          enable = true;
          ai.enable = true;
          jump.enable = true;
        };
      };

      # todo: where???
      # extraPlugins = [ pkgs.vimExtraPlugins.supermaven-nvim ];
    };
  };
}
