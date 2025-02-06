{ pkgs, lib, inputs, ... }:

{
  home-manager.users.vitalya.programs.vscode = with pkgs; {
    enable = true;
    package = vscode;
    mutableExtensionsDir = false;

    userSettings = lib.importJSON ./settings.json;
    keybindings = lib.importJSON ./keybindings.json;

    extensions = with (inputs.nix-vscode-extensions.extensions.${pkgs.system}.forVSCodeVersion inputs.nixpkgs.legacyPackages.${pkgs.system}.vscode.version).vscode-marketplace; [
      vscodevim.vim

      jnoortheen.nix-ide

      eamodio.gitlens
      mhutchie.git-graph

      ms-vscode-remote.remote-containers
      ms-azuretools.vscode-docker

      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      bradlc.vscode-tailwindcss

      wmaurer.change-case
      redhat.vscode-yaml
      oderwat.indent-rainbow

      dart-code.flutter
      dart-code.dart-code

      rust-lang.rust-analyzer
      vadimcn.vscode-lldb

      biomejs.biome

      akamud.vscode-theme-onedark
      vscode-ext.sync-rsync
      fabiospampinato.vscode-commands
      ms-vscode.remote-explorer
      oven.bun-vscode

      wakatime.vscode-wakatime
    ] ++ (with pkgs.vscode-extensions; [
      ms-vscode-remote.remote-ssh
    ]);
  };
}
