{ ... }:

let mkApp = import ./_mk-app.nix;
in
{
  den.aspects.ollama = mkApp {
    home = {
      services.ollama.enable = true;
    };
  };
}
