{ lib, config, pkgs, options, ... }:

{
  options.modules.dev.enable-nix-ld = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Nix-LD for Zed language servers";
  };

  config = lib.mkMerge [
    {
      home-manager.users.vitalya.programs.zed-editor = {
        enable = true;
        extensions = [ "nix" ];
        extraPackages = [ pkgs.nil ];
        userSettings = {
          agent = {
            default_model = {
              provider = "zed.dev";
              model = "grok-code-fast-1";
            };
            play_sound_when_agent_done = true;
            model_parameters = [ ];
          };
          collaboration_panel = {
            button = false;
          };
          project_panel = {
            hide_hidden = false;
            hide_root = false;
            indent_size = 20.0;
            hide_gitignore = false;
          };
          use_system_window_tabs = false;
          tab_bar = {
            show_nav_history_buttons = false;
          };
          tabs = {
            file_icons = false;
            git_status = true;
          };
          title_bar = {
            show_branch_icon = false;
            show_user_picture = false;
          };
          prettier = {
            allowed = false;
          };
          indent_guides = {
            background_coloring = "disabled";
            coloring = "indent_aware";
          };
          minimap = {
            max_width_columns = 70;
            show = "auto";
          };
          autoscroll_on_clicks = true;
          auto_update = false;
          vim_mode = true;
          terminal = {
            toolbar = {
              breadcrumbs = false;
            };
            max_scroll_history_lines = 10000000;
          };
          base_keymap = "VSCode";
          autosave = "on_focus_change";
          buffer_font_fallbacks = [
            "Droid Sans Mono"
            "monospace"
          ];
          buffer_font_family = "Fira Code";
          linked_edits = true;
          show_whitespaces = "all";
          wrap_guides = [
            100
          ];
          tab_size = 2;
          icon_theme = {
            mode = "system";
            light = "Zed (Default)";
            dark = "Zed (Default)";
          };
          ui_font_size = 15.0;
          buffer_font_size = 12.0;
          theme = "One Dark";
          languages = {
            TypeScript = {
              prettier = {
                allowed = true;
              };
            };
            JavaScript = {
              prettier = {
                allowed = true;
              };
            };
          };
        };
      };
    }

    (if (builtins.hasAttr "homebrew" options) then { } else {
      programs.nix-ld = lib.mkIf config.modules.dev.enable-nix-ld {
        enable = true;
      };
    })
  ];
}
