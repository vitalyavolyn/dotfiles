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
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        clock-show-weekday = true;
      };

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

      "org/gnome/desktop/wm/keybindings" = {
        switch-input-source = [ "<Control>space" ];
        switch-input-source-backward = [ "<Shift><Control>space" ];
      };

      "org/gnome/shell" = {
        disable-user-extensions = false;

        # `gnome-extensions list` for a list
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "screen-rotate@shyzus.github.io"
          "wiggle@mechtifs"
          "Bluetooth-Battery-Meter@maniacx.github.com"
          "search-light@icedman.github.com"
          "windowIsReady_Remover@nunofarruca@gmail.com"
          "pip-on-top@rafostar.github.com"
        ] ++ optionals (hasModule "tailscale") [
          "tailscale@joaophi.github.com"
        ];

        favorite-apps =
          [ "org.gnome.Nautilus.desktop" ]
          ++ [ "kitty.desktop" ]
          ++ optionals (hasModule "chrome") [ "google-chrome.desktop" ]
          ++ optionals (hasModule "firefox") [ "firefox.desktop" ]
          ++ optionals (hasModule "dev") [ "code.desktop" ]
          ++ optionals (hasModule "dev") [ "dev.zed.Zed.desktop" ]
          ++ optionals (hasModule "messaging") [ "org.telegram.desktop.desktop" ]
          ++ optionals (hasModule "messaging") [ "discord.desktop" ]
          ++ optionals (hasModule "spotify") [ "spotify.desktop" ]
          ++ optionals (hasModule "steam") [ "steam.desktop" ]
          ++ optionals (hasModule "minecraft") [ "org.prismlauncher.PrismLauncher.desktop" ];
      };

      "org/gnome/mutter" = {
        dynamic-workspaces = false;
        edge-tiling = true;
        center-new-windows = true;
      };

      "org/gnome/shell/extensions/Bluetooth-Battery-Meter" = {
        enable-battery-level-text = true;
        enable-battery-level-icon = false;
        enable-battery-indicator = false;
        indicator-type = 0;
        popup-in-quick-settings = false;
      };

      "org/gnome/shell/extensions/search-light" = {
        shortcut-search = [ "<Super>space" ];
        border-radius = 3.0;
        background-color = lib.gvariant.mkTuple [ 0.0 0.0 0.0 0.5 ];
      };
    };
  };
}
