{ pkgs, lib, ... }:

{
  home-manager.users.vitalya.programs.vscode = with pkgs; {
    enable = true;
    package = vscode;
    mutableExtensionsDir = false;

    userSettings = lib.importJSON ./settings.json;
    keybindings = lib.importJSON ./keybindings.json;

    extensions = with vscode-extensions; [
      vscodevim.vim

      jnoortheen.nix-ide

      eamodio.gitlens
      mhutchie.git-graph

      ms-vscode-remote.remote-ssh
      ms-azuretools.vscode-docker

      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      bradlc.vscode-tailwindcss

      wmaurer.change-case
      redhat.vscode-yaml
      oderwat.indent-rainbow

      dart-code.flutter
      dart-code.dart-code

      ziglang.vscode-zig

      vscode-extensions.supermaven.supermaven
    ] ++ vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-theme-onedark";
        publisher = "akamud";
        version = "2.3.0";
        sha256 = "1km3hznw8k0jk9sp3r81c89fxa311lc6gw20fqikd899pvhayqgh";
      }
      {
        name = "sync-rsync";
        publisher = "vscode-ext";
        version = "0.36.0";
        sha256 = "sha256-0b/OHLZfXo0NAVAVkzZSqMGDzF0uvPRoiqsZtW1iOdA=";
      }
      {
        name = "vscode-commands";
        publisher = "fabiospampinato";
        version = "2.0.2";
        sha256 = "sha256-W8P73yzkZRRN2Tq8uz8tWtNFSrjblw/Gzps9ldMPaaw=";
      }
      {
        name = "remote-explorer";
        publisher = "ms-vscode";
        version = "0.5.2024070409";
        sha256 = "sha256-YwmsZii8TvBhloNQi6mezusEf/SmIq3i1ZNyKN5j1sU=";
      }
    ];
  };
}
