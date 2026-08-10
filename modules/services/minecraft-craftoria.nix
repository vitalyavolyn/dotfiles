import ./minecraft-server.nix {
  name = "minecraft-craftoria";
  cfSlug = "craftoria";
  port = 1349;
  maxMemory = "6G";
}
