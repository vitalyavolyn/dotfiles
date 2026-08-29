let
  vitalya = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJOIQWALhrUwF6a23G9g3i/LjI50Bl/PGO1RauHJBks";

  porygon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL4f7e//awLVJfJ3bF3LTOpUJMutL1utX1n59IhEfmC6";
  applin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICOaxeBviEzDK8dORcoynD92597h9BUrk3Mw3r8TsgIK";
  shinx = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOQusNBR22rntTIJao2YGvrfxutxAuaaWybufLEM362";
  tynamo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPv60/MCIjY3P3oBh+q4uCqjSKoQY4mvNwVjOvWC/fuo";

  systems = [ porygon applin shinx ];
in
{
  "curseforge-token.age".publicKeys = [ vitalya ] ++ systems;
  "paperless-password.age".publicKeys = [ vitalya ] ++ systems;

  # CLOUDFLARE_DNS_API_TOKEN=<token with Zone:Read + DNS:Edit scoped to eepo.boo>
  # Used by security.acme on porygon for the *.eepo.boo wildcard cert
  "cloudflare-acme.age".publicKeys = [ vitalya porygon shinx ];

  # Cloudflare Tunnel credentials JSON from: cloudflared tunnel create ha-tunnel
  # Used by cloudflared on shinx
  "cloudflared-credentials.age".publicKeys = [ vitalya shinx ];

  # Forgejo Actions runner registration token, from Forgejo's admin panel
  # (Site Administration -> Actions -> Runners -> Create new Runner).
  # Used by forgejo-runner on porygon.
  "forgejo-runner-token.age".publicKeys = [ vitalya porygon ];

  # Forgejo Actions runner registration token for the x86_64 runner on shinx
  "forgejo-runner-token-shinx.age".publicKeys = [ vitalya shinx ];

  "hermes-env.age".publicKeys = [ vitalya shinx ];

  # A stable HERMES_DASHBOARD_SESSION_TOKEN — pasted once into the Hermes
  # Desktop app's Settings -> Gateway -> Remote gateway -> Session token
  # field on applin/tynamo, so they connect to shinx's backend instead of
  # each starting its own separate agent. Only shinx needs to decrypt this;
  # the other hosts just need the value typed into the app once.
  "hermes-dashboard-token.age".publicKeys = [ vitalya shinx ];
}
