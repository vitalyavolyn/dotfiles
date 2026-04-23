{
  # True when running under nix-darwin
  isDarwin = options: builtins.hasAttr "homebrew" options;

  # Tailscale-only nginx vhost with eepo.boo wildcard cert, restricted to 100.0.0.0/8
  tsOnly = backend: {
    useACMEHost = "eepo.boo";
    forceSSL = true;
    extraConfig = "allow 100.0.0.0/8; deny all;";
    locations."/" = { proxyPass = backend; proxyWebsockets = true; };
  };
}
