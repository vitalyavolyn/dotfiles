# ELAN 04f3:0c6e fingerprint reader (ROG Flow X13 power button).
# It is a small 150x52 press sensor, but upstream libfprint drives it as a
# swipe sensor (stitching identical frames into garbage) and matches with
# NBIS, which can't find enough minutiae on images this small. So:
#  - libfprint comes from the goodix-fp-linux-dev fork, which adds the
#    SIFT-based SIGFM matcher for small sensors
#  - the patch makes the elan driver treat 0c6e as a press sensor: single
#    normalized frame instead of stitching, a clean background even when the
#    finger is still on the sensor, 30 enroll stages, and SIGFM matching
{ pkgs, ... }:

let
  libfprint = pkgs.libfprint.overrideAttrs (old: {
    version = "1.94.5-sigfm";
    src = pkgs.fetchFromGitHub {
      owner = "goodix-fp-linux-dev";
      repo = "libfprint";
      rev = "07306bbc9256942595e31fb0f407b364ffa24d07"; # sigfm branch
      hash = "sha256-HNFR+5kWHhG4inIn1An4aJ1RoieHbNh5aiTW0g5hAV0=";
    };
    patches = [ ./libfprint-sigfm-elan-0c6e.patch ];
    buildInputs = old.buildInputs ++ [ pkgs.opencv pkgs.doctest pkgs.nss ];
    # the fork's virtual-image tests fail against current glib; the check
    # inputs still have to stay enabled since meson needs them to configure
    installCheckPhase = "true";
    # fprintd from nixpkgs requires >= 1.94.9; the fork's API is compatible
    postPatch = old.postPatch + ''
      substituteInPlace meson.build --replace-fail "version: '1.94.5'" "version: '1.94.9'"
      # enum value added upstream after the fork, used by fprintd
      substituteInPlace libfprint/fp-device.h --replace-fail \
        "FP_DEVICE_RETRY_REMOVE_FINGER,
} FpDeviceRetry;" \
        "FP_DEVICE_RETRY_REMOVE_FINGER,
  FP_DEVICE_RETRY_TOO_FAST,
} FpDeviceRetry;"
    '';
    # fp-image.h includes this header but the fork doesn't install it
    postInstall = (old.postInstall or "") + ''
      install -Dm644 ../libfprint/sigfm/sigfm.hpp $out/include/libfprint-2/sigfm/sigfm.hpp
    '';
  });
in
{
  services.fprintd = {
    enable = true;
    package = pkgs.fprintd.override { inherit libfprint; };
  };
}
