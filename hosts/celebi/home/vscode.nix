{ pkgs, lib, ... }:

{
  programs.vscode = with pkgs; {
    enable = true;
    package = vscode;
    mutableExtensionsDir = false;

    userSettings = lib.importJSON ./configs/vscode/settings.json;
    keybindings = lib.importJSON ./configs/vscode/keybindings.json;

    extensions = with vscode-extensions; [
      jnoortheen.nix-ide

      eamodio.gitlens
      mhutchie.git-graph

      ms-vscode-remote.remote-ssh
      ms-azuretools.vscode-docker

      dbaeumer.vscode-eslint
      esbenp.prettier-vscode

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
        sha256 = "sha256-8GGv4L4poTYjdkDwZxgNYajuEmIB5XF1mhJMxO2Ho84=";
      }
      {
        name = "supermaven";
        publisher = "supermaven";
        version = "0.1.45";
        sha256 = "sha256-qAi++JbivmMH1nTZh/pRkoae35OLUypElxPjWlrMxxk=";
      }
      {
        name = "bongocat-buddy";
        publisher = "JohnHarrison";
        version = "1.6.0";
        sha256 = "sha256-Oz7cmu3uY9De+EU3V/G59f2LeAOrwpwftxtIp/IPT3c=";
      }
    ];
  };
}
