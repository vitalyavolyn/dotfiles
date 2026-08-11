{ den, ... }:

{
  den.aspects.dconf = { host, ... }: {
    nixos.programs.dconf.enable = true;

    homeManager =
      { lib, ... }:
      let
        hasAspect = aspect: host.hasAspect aspect;
      in
      {
        dconf = {
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
              switch-input-source = [ "<Control>space" ];
              switch-input-source-backward = [ "<Shift><Control>space" ];
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
                "screen-rotate@shyzus.github.io"
                "wiggle@mechtifs"
                "Bluetooth-Battery-Meter@maniacx.github.com"
                "search-light@icedman.github.com"
                "windowIsReady_Remover@nunofarruca@gmail.com"
                "pip-on-top@rafostar.github.com"
              ] ++ lib.optionals (hasAspect den.aspects.tailscale) [
                "tailscale-gnome-qs@tailscale-qs.github.io"
              ];

              favorite-apps =
                [ "org.gnome.Nautilus.desktop" ]
                ++ [ "kitty.desktop" ]
                ++ lib.optionals (hasAspect den.aspects.chrome) [ "google-chrome.desktop" ]
                ++ lib.optionals (hasAspect den.aspects.firefox) [ "firefox.desktop" ]
                ++ lib.optionals (hasAspect den.aspects.helium) [ "helium.desktop" ]
                ++ lib.optionals (hasAspect den.aspects.dev) [ "code.desktop" ]
                ++ lib.optionals (hasAspect den.aspects.dev) [ "dev.zed.Zed.desktop" ]
                ++ lib.optionals (hasAspect den.aspects.messaging) [ "org.telegram.desktop.desktop" ]
                ++ lib.optionals (hasAspect den.aspects.messaging) [ "discord.desktop" ]
                ++ lib.optionals (hasAspect den.aspects.spotify) [ "spotify.desktop" ]
                ++ lib.optionals (hasAspect den.aspects.steam) [ "steam.desktop" ]
                ++ lib.optionals (hasAspect den.aspects.minecraft) [ "org.prismlauncher.PrismLauncher.desktop" ];
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
      };
  };
}
