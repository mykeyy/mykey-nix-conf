{ lib, stdenv, zig, beansproutSrc, wayland, wayland-scanner, wayland-protocols, pixman, fcft, libxkbcommon, pkg-config }:

stdenv.mkDerivation {
  pname = "beansprout";
  version = "1.1.0-dev-unstable-2026-06-04";

  src = beansproutSrc;

  nativeBuildInputs = [ zig pkg-config ];
  buildInputs = [ wayland wayland-scanner wayland-protocols pixman fcft libxkbcommon ];

  dontConfigure = true;
  __noChroot = true;

  buildPhase = ''
    export ZIG_GLOBAL_CACHE_DIR="$TMPDIR/zig-cache"
    zig build -Doptimize=ReleaseSafe
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp zig-out/bin/beansprout $out/bin/
  '';

  meta = {
    description = "A DWM-style tiling window manager for the river Wayland compositor";
    homepage = "https://codeberg.org/beansprout/beansprout";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
