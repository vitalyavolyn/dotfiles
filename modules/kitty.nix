{ ... }:

{
  home-manager.users.vitalya.programs.kitty = {
    enable = true;
    font.name = "Fira Code";
    theme = "Afterglow";
    settings = {
      confirm_os_window_close = 0;
    };
    shellIntegration.enableZshIntegration = true;
  };
}
