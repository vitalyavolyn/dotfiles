{ pkgs, ... }:

{
  home-manager.users.vitalya = {
    home = {
      pointerCursor = {
        x11.enable = true;
        package = pkgs.paper-icon-theme;
        name = "Paper";
        size = 16;
      };
    };

    gtk = {
      enable = true;
      # theme = {
      #   package = pkgs.arc-theme;
      #   name = "Arc-Dark";
      # };
      iconTheme = {
        package = pkgs.paper-icon-theme;
        name = "Paper";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
    };
  };
}
