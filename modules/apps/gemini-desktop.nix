{ ... }:

{
  den.aspects.gemini-desktop = {
    nixos = {
      warnings = [ "gemini-desktop module is broken on Linux, skipping" ];
    };
    darwin.homebrew.casks = [ "google-gemini" ];
  };
}
