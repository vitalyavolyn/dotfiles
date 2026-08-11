{ ... }:

{
  den.aspects.claude-desktop = {
    nixos = {
      warnings = [ "claude-desktop module is broken on Linux, skipping" ];
    };
    darwin.homebrew.casks = [ "claude" ];
  };
}
