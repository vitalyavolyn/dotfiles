{ inputs, ... }:

{
  homebrew.casks = [ "hammerspoon" ];

  home-manager.users.vitalya.home.file.".hammerspoon" = {
    source = ./hammerspoon;
    recursive = true;
  };

  home-manager.users.vitalya.home.file.".hammerspoon/Spoons/PaperWM.spoon" = {
    source = inputs.paperwm-spoon;
    recursive = true;
  };
}
