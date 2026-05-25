{
  lib,
  stdenv,
  zig_0_15,
  makeWrapper,
  coreutils,
  grim,
  slurp,
  wl-clipboard,
  libnotify,
}:

stdenv.mkDerivation {
  pname = "screenshot";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ zig_0_15 makeWrapper ];

  dontConfigure = true;

  preBuild = ''
    export ZIG_GLOBAL_CACHE_DIR=$TMPDIR/zig-global-cache
  '';

  buildPhase = ''
    runHook preBuild
    zig build-exe src/main.zig \
      -O ReleaseSafe \
      --cache-dir $TMPDIR/zig-cache \
      -femit-bin=screenshot
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 screenshot $out/bin/screenshot
    wrapProgram $out/bin/screenshot \
      --prefix PATH : ${lib.makeBinPath [ coreutils grim slurp wl-clipboard libnotify ]}
    runHook postInstall
  '';
}
