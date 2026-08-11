# Destinations: `nixos`/`darwin`/`os` → OS, `home`/`*Home*` → Home Manager, casks → Homebrew.
{ nixos ? null
, darwin ? null
, os ? null
, home ? null
, nixosHome ? null
, darwinHome ? null
, nixosHomePackages ? null
, darwinHomePackages ? null
, darwinCasks ? [ ]
,
}:

{ host, ... }:

let
  imports = modules: builtins.filter (module: module != null) modules;
  packagesModule = packages:
    if packages == null then null else
    { pkgs, ... }: {
      home.packages = if builtins.isFunction packages then packages pkgs else packages;
    };
  mkHome = platformModule: packages: {
    imports = imports [ home platformModule (packagesModule packages) ];
  };
in
if host.class == "nixos" then
  {
    nixos.imports = imports [ os nixos ];
    homeManager = mkHome nixosHome nixosHomePackages;
  }
else if host.class == "darwin" then
  {
    darwin = {
      imports = imports [ os darwin ];
      homebrew.casks = darwinCasks;
    };
    homeManager = mkHome darwinHome darwinHomePackages;
  }
else
  throw "unsupported host class: ${host.class}"
