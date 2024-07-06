let
  vitalya = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJOIQWALhrUwF6a23G9g3i/LjI50Bl/PGO1RauHJBks";

  porygon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL4f7e//awLVJfJ3bF3LTOpUJMutL1utX1n59IhEfmC6";
  applin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOaxeBviEzDK8dORcoynD92597h9BUrk3Mw3r8TsgIK";
  systems = [ porygon applin ];
in
{
  "curseforge-token.age".publicKeys = [ vitalya ] ++ systems;
}
