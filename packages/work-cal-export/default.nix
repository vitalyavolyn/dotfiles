{ stdenv, swift }:

stdenv.mkDerivation {
  pname = "work-cal-export";
  version = "1.0.0";
  src = ./work-cal-export.swift;
  dontUnpack = true;
  nativeBuildInputs = [ swift ];

  buildPhase = ''
    runHook preBuild
    swiftc -parse-as-library "$src" -o work-cal-export
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp work-cal-export $out/bin/
    runHook postInstall
  '';
}
