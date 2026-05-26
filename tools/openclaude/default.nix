{ pkgs, lib, ... }:
pkgs.symlinkJoin {
  name = "openclaude";
  paths = [
    (pkgs.writeShellScriptBin "openclaude" ''
      export PATH="${lib.makeBinPath [ pkgs.ripgrep pkgs.nodejs ]}:$PATH"
      exec ${pkgs.nodejs}/bin/npx --yes @gitlawb/openclaude "$@"
    '')
  ];
  postBuild = ''
    ln -s $out/bin/openclaude $out/bin/openclaw
  '';
}
