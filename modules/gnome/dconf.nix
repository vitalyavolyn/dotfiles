{ lib, config, ... }:

let
  hasModule = name: builtins.hasAttr name config.modules;
  optionals = lib.optionals;
in
{
  programs.dconf.enable = true;

  home-manager.users.vitalya.dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";

      "org/gnome/desktop/wm/preferences".num-workspaces = 5;

      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Shift><Super>q" ];
        move-to-workspace-1 = [ "<Shift><Super>1" ];
        move-to-workspace-2 = [ "<Shift><Super>2" ];
        move-to-workspace-3 = [ "<Shift><Super>3" ];
        move-to-workspace-4 = [ "<Shift><Super>4" ];
        move-to-workspace-5 = [ "<Shift><Super>5" ];
        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];
        switch-to-workspace-5 = [ "<Super>5" ];
      };

      "org/gnome/shell/keybindings" = {
        switch-to-application-1 = [ ];
        switch-to-application-2 = [ ];
        switch-to-application-3 = [ ];
        switch-to-application-4 = [ ];
        switch-to-application-5 = [ ];
      };

      "org/gnome/shell" = {
        disable-user-extensions = false;

        # `gnome-extensions list` for a list
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
        ];

        favorite-apps =
          [ "org.gnome.Nautilus.desktop" ]
          ++ [ "kitty.desktop" ]
          ++ optionals (hasModule "browser") [ "google-chrome.desktop" ]
          ++ optionals (hasModule "dev") [ "code.desktop" ]
          ++ optionals (hasModule "messaging") [ "org.telegram.desktop.desktop" ]
          ++ optionals (hasModule "messaging") [ "discord.desktop" ]
          ++ optionals (hasModule "spotify") [ "spotify.desktop" ];
      };

      "org/gnome/mutter" = {
        edge-tiling = true;
        center-new-windows = true;
      };
    };
  };
}
