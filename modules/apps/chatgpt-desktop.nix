{ ... }:

{
  den.aspects.chatgpt-desktop = {
    nixos = {
      warnings = [ "chatgpt-desktop is not packaged for Linux, skipping" ];
    };
    darwin.homebrew.casks = [ "chatgpt" ];
  };
}
