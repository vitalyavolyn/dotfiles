{ pkgs, ... }:

{
  home-manager.users.vitalya = {
    gtk = {
      enable = true;
      theme = {
        package = pkgs.arc-theme;
        name = "Arc-Dark";
      };
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
