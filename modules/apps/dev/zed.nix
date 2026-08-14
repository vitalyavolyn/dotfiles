{ ... }:

{
  den.aspects.zed.homeManager = { pkgs, ... }:
    let
      nilFormatter = pkgs.writeShellScript "nil-nix-fmt" ''
        set -euo pipefail
        tmp=$(${pkgs.coreutils}/bin/mktemp --suffix=.nix)
        trap '${pkgs.coreutils}/bin/rm -f "$tmp"' EXIT
        ${pkgs.coreutils}/bin/cat > "$tmp"
        ${pkgs.nix}/bin/nix fmt "$tmp" >/dev/null 2>&1
        ${pkgs.coreutils}/bin/cat "$tmp"
      '';
    in
    {
      programs.zed-editor = {
        enable = true;
        extensions = [ "nix" ];
        extraPackages = [ pkgs.nil ];
        userSettings = {
          agent = {
            dock = "right";
            sidebar_side = "right";
            play_sound_when_agent_done = "always";
            model_parameters = [ ];
          };
          agent_servers.claude-acp = {
            type = "registry";
            default_config_options.mode = "bypassPermissions";
          };
          agent_servers.codex-acp = {
            type = "registry";
          };
          edit_predictions.provider = "none";
          diff_view_style = "unified";
          collaboration_panel = {
            dock = "left";
            button = false;
          };
          project_panel = {
            dock = "left";
            hide_hidden = false;
            hide_root = false;
            indent_size = 20.0;
            hide_gitignore = false;
          };
          use_system_window_tabs = false;
          tab_bar.show_nav_history_buttons = false;
          tabs = {
            file_icons = false;
            git_status = true;
          };
          title_bar.show_user_picture = false;
          prettier.allowed = false;
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
            toolbar.breadcrumbs = false;
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
          wrap_guides = [ 100 ];
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
            TypeScript.prettier.allowed = true;
            JavaScript.prettier.allowed = true;
            Nix.language_servers = [ "nil" "!nixd" ];
          };
          outline_panel.dock = "left";
          git_panel.dock = "left";
          lsp.nil.settings = {
            nix.flake.autoArchive = true;
            formatting.command = [ "${nilFormatter}" ];
          };
        };
      };
    };
}
