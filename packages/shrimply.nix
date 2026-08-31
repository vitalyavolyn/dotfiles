{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, symlinkJoin
, makeRustPlatform
, rust-bin
, pkg-config
, makeWrapper
, cmake
, ninja
, python3
, gn
, clang_22
, llvmPackages_22
, cudaPackages_13
, gtk4
, libadwaita
, gobject-introspection
, ffmpeg
, rubberband
, alsa-lib
, pipewire
, libglvnd
, gtksourceview5
, vte-gtk4
, poppler
, freetype
, openssl
, opencv
, boost
, libffi
, libxml2
, zstd
, zlib
, hicolor-icon-theme
, adwaita-icon-theme
,
}:

let
  rustToolchain = rust-bin.fromRustupToolchain {
    channel = "nightly-2026-04-03";
    components = [ "rust-src" "rustc-dev" "llvm-tools" "rustfmt" "clippy" ];
  };
  rustPlatform = makeRustPlatform {
    cargo = rustToolchain;
    rustc = rustToolchain;
  };
  shrimplySrc = fetchFromGitHub {
    owner = "soirihiroka";
    repo = "shrimply";
    rev = "0caceec9f4507c0ab42352b37660c4cb8a499e7b";
    fetchSubmodules = true;
    hash = "sha256-19w8jqapwEKgZQX8o10kdoyuTmMAqLGiRik2iWLvQSU=";
  };
  oxideCargoDeps = rustPlatform.fetchCargoVendor {
    src = shrimplySrc;
    cargoRoot = "external/cuda-oxide";
    hash = "sha256-zQTTSFhxK6ERd5kJNYS8sKwqvEgMA8nZx3YrammHBbE=";
  };
  hostCargoDeps = rustPlatform.fetchCargoVendor {
    src = shrimplySrc;
    hash = "sha256-fWOpWnV6vjWnHwq1LR64NUN81RmFey/g08aHrkG4mQk=";
  };
  backendCargoDeps = rustPlatform.fetchCargoVendor {
    src = shrimplySrc;
    cargoRoot = "external/cuda-oxide/crates/rustc-codegen-cuda";
    hash = "sha256-Kz3t0sNPzc2RNUpXuO5V2TXxztdVvpE2TBnGjW//l70=";
  };
  skiaBinaries = fetchurl {
    url = "https://github.com/rust-skia/skia-binaries/releases/download/0.99.0/skia-binaries-a25a0fdb7d90429aa2d1-x86_64-unknown-linux-gnu-egl-gl-jpegd-jpege-pdf-skottie-svg-textlayout-vulkan-wayland-webpd-webpe-x11.tar.gz";
    hash = "sha256-u+Oec2kkFbGy5dVZGcaUisun0WryJ3xmTK6cHHe2OzA=";
  };
  cuda = cudaPackages_13;
  cudaToolkit = symlinkJoin {
    name = "shrimply-cuda-toolkit-${cuda.cuda_nvcc.version}";
    paths = [
      cuda.cuda_nvcc
      cuda.cuda_cudart
      cuda.cuda_crt
      cuda.cccl
      cuda.libnvvm
      cuda.libnvjitlink.lib
      cuda.libcublas.lib
      cuda.libcublas.include
    ];
  };
in
rustPlatform.buildRustPackage rec {
  pname = "shrimply";
  version = "0-unstable-2026-08-31";

  src = shrimplySrc;

  cargoDeps = hostCargoDeps;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    cmake
    ninja
    python3
    gn
    clang_22
    llvmPackages_22.libclang
  ];

  buildInputs = [
    gtk4
    libadwaita
    gobject-introspection
    ffmpeg
    rubberband
    alsa-lib
    pipewire
    libglvnd
    gtksourceview5
    vte-gtk4
    poppler
    freetype
    openssl
    opencv
    boost
    libffi
    libxml2
    zstd
    zlib
    hicolor-icon-theme
    adwaita-icon-theme
  ];

  CUDA_HOME = cudaToolkit;
  CUDA_TOOLKIT_PATH = cudaToolkit;
  CUDA_OXIDE_TARGET = "sm_86";
  CUDA_OXIDE_DEBUG = "off";
  LIBCLANG_PATH = "${llvmPackages_22.libclang.lib}/lib";
  SLANG_SOURCE_DIR = "external/slang";
  SLANG_BUILD_DIR = "external/slang/build";
  OPTIX_ROOT = "external/optix-dev";
  SKIA_BINARIES_URL = "file://${skiaBinaries}";

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '$(RUSTUP) run $(RUST_TOOLCHAIN) cargo' 'cargo'

    # register_bundled() hardcodes a CARGO_MANIFEST_DIR-relative search path
    # for the ~90 custom symbolic icons, which only exists inside the build
    # sandbox. Make it overridable at runtime so we can point it at the
    # icons we install into $out, otherwise every toolbar/UI icon is blank.
    cat > crates/ui/ui-foundation/src/icons.rs <<'EOF'
use std::path::{Path, PathBuf};

pub fn register_bundled() {
    let Some(display) = gtk::gdk::Display::default() else {
        return;
    };
    let path = std::env::var_os("SHRIMPLY_ICON_DIR")
        .map(PathBuf::from)
        .unwrap_or_else(|| Path::new(env!("CARGO_MANIFEST_DIR")).join("../../../assets/icons"));
    gtk::IconTheme::for_display(&display).add_search_path(path);
}
EOF
  '';

  buildPhase = ''
    runHook preBuild
    export PATH=${cudaToolkit}/bin:$PATH
    export SLANG_SOURCE_DIR=$PWD/external/slang
    export SLANG_BUILD_DIR=$PWD/external/slang/build
    export OPTIX_ROOT=$PWD/external/optix-dev
    mkdir -p $TMPDIR/merged-cargo-vendor/source-registry-0
    for crate in \
      ${hostCargoDeps}/source-registry-0/* \
      ${oxideCargoDeps}/source-registry-0/* \
      ${backendCargoDeps}/source-registry-0/*; do
      ln -s "$crate" $TMPDIR/merged-cargo-vendor/source-registry-0/$(basename "$crate") 2>/dev/null || true
    done
    for source in ${oxideCargoDeps}/source-git-*; do
      ln -s "$source" $TMPDIR/merged-cargo-vendor/$(basename "$source")
    done
    mkdir -p $TMPDIR/merged-cargo-home
    sed 's|@vendor@|'$TMPDIR/merged-cargo-vendor'|g' \
      ${oxideCargoDeps}/.cargo/config.toml \
      > $TMPDIR/merged-cargo-home/config.toml
    cp $TMPDIR/merged-cargo-home/config.toml .cargo/config.toml
    chmod +w .cargo/config.toml
    printf '\n[target.x86_64-unknown-linux-gnu]\nrustflags = ["-C", "link-arg=-fuse-ld=lld"]\n' \
      >> .cargo/config.toml
    export CARGO_HOME=$TMPDIR/merged-cargo-home
    CARGO_TARGET_DIR=target/oxide-cli cargo build --release \
      --manifest-path external/cuda-oxide/Cargo.toml \
      --package cargo-oxide
    export PATH=$PWD/target/oxide-cli/release:$PATH
    (cd external/cuda-oxide && cargo oxide setup)
    make release \
      CARGO=cargo \
      PKG_CONFIG=${pkg-config}/bin/pkg-config \
      CUDA_HOME=${cudaToolkit} \
      CUDA_TOOLKIT_PATH=${cudaToolkit} \
      CUDA_OXIDE_TARGET=sm_86
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install \
      CARGO=cargo \
      PREFIX=$out \
      DESTDIR= \
      PKG_CONFIG=${pkg-config}/bin/pkg-config \
      CUDA_HOME=${cudaToolkit} \
      CUDA_TOOLKIT_PATH=${cudaToolkit} \
      CUDA_OXIDE_TARGET=sm_86
    mkdir -p $out/share/shrimply/icons
    cp assets/icons/*.svg $out/share/shrimply/icons/
    # Shrimply's preview GLArea never pins gdk::GLAPI::GL, so GTK4's default
    # EGL negotiation hands it a GLES context; its preview shader is hardcoded
    # `#version 330 core` (desktop-only) and fails to compile under GLES.
    # gl-prefer-gl makes GDK request desktop GL instead.
    #
    # On this hybrid NVIDIA/AMD laptop, GDK's EGL device selection lands on
    # the AMD iGPU while the video compositor's CUDA context is bound to the
    # NVIDIA dGPU, so cuGraphicsGLRegisterImage (which requires both contexts
    # on the same physical GPU) fails and the CUDA-composited preview falls
    # back to an error placeholder for those frames. Forcing EGL to the
    # NVIDIA vendor ICD via __EGL_VENDOR_LIBRARY_FILENAMES "fixes" that but
    # makes GDK's *shared* EGL display (one per Wayland connection, used by
    # the whole UI) intermittently fail to initialize against NVIDIA
    # instead, which is strictly worse. Standard PRIME render offload
    # (matching hardware.nvidia.prime.offload's own nvidia-offload script in
    # asus-rog-stuff.nix) is the correct, non-destructive fix: it tells
    # NVIDIA's driver to render there while still cooperating with the
    # AMD-backed display via its own dma-buf handoff, instead of excluding
    # Mesa from EGL vendor negotiation entirely.
    wrapProgram $out/bin/shrimply \
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib \
      --prefix XDG_DATA_DIRS : ${hicolor-icon-theme}/share:${adwaita-icon-theme}/share \
      --suffix GDK_DEBUG : gl-prefer-gl \
      --set __NV_PRIME_RENDER_OFFLOAD 1 \
      --set __NV_PRIME_RENDER_OFFLOAD_PROVIDER NVIDIA-G0 \
      --set __GLX_VENDOR_LIBRARY_NAME nvidia \
      --set __VK_LAYER_NV_optimus NVIDIA_only \
      --set SHRIMPLY_ICON_DIR "$out/share/shrimply/icons"
    wrapProgram $out/bin/shrimply-editor \
      --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib \
      --prefix XDG_DATA_DIRS : ${hicolor-icon-theme}/share:${adwaita-icon-theme}/share \
      --suffix GDK_DEBUG : gl-prefer-gl \
      --set __NV_PRIME_RENDER_OFFLOAD 1 \
      --set __NV_PRIME_RENDER_OFFLOAD_PROVIDER NVIDIA-G0 \
      --set __GLX_VENDOR_LIBRARY_NAME nvidia \
      --set __VK_LAYER_NV_optimus NVIDIA_only \
      --set SHRIMPLY_ICON_DIR "$out/share/shrimply/icons"
    runHook postInstall
  '';

  doCheck = false;

  meta = {
    description = "CUDA-accelerated GTK video editor";
    homepage = "https://shrimply.pages.dev/";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "shrimply";
  };
}
