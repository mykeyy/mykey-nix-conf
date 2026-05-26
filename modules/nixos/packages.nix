{ ... }:
{
  flake.modules.nixos.packages = { pkgs, ... }: {
    nixpkgs.overlays = [
      (final: prev: {
        opencode = prev.opencode.overrideAttrs (old: {
          nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.makeWrapper ];
          buildInputs = (old.buildInputs or [ ]) ++ [ final.stdenv.cc.cc.lib ];
          postFixup = (old.postFixup or "") + ''
            wrapProgram $out/bin/opencode \
              --prefix LD_LIBRARY_PATH : ${final.stdenv.cc.cc.lib}/lib
          '';
        });
      })
    ];
    environment.systemPackages = with pkgs; [
      wget
      vim
      git
    ];
  };
}
