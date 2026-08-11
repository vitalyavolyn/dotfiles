{ ... }:

{
  den.aspects.minecraft-skyfactory-5.nixos = {
    imports = [
      (import ./_minecraft-server.nix {
        name = "minecraft-skyfactory-5";
        cfSlug = "skyfactory-5";
        port = 1350;
        javaVersion = "java17";
      })
    ];
  };
}
