{ pkgs, lib, ... }:

{
  home-manager.users.vitalya.programs.vscode = with pkgs; {
    enable = true;
    package = vscode;
    mutableExtensionsDir = false;

    userSettings = lib.importJSON ./settings.json;
    keybindings = lib.importJSON ./keybindings.json;

    extensions = with vscode-extensions; [
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
    ] ++ vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-theme-onedark";
        publisher = "akamud";
        version = "2.3.0";
        sha256 = "1km3hznw8k0jk9sp3r81c89fxa311lc6gw20fqikd899pvhayqgh";
      }
      {
        name = "supermaven";
        publisher = "supermaven";
        version = "0.2.1";
        sha256 = "03i32zkgbcnh5vpmcnab8dvl6mf3dd9kzw1izms2lhjn5kznxgiw";
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
        version = "0.5.2024061309";
        sha256 = "sha256-L9/4lB47rCpAscZlJYDDHMWXhw+FEHHNvqN53j5/TMM=";
      }
    ];
  };
}
