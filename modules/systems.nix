{ lib, ... }:
{
  options.flake.modules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = { };
  };

  config.systems = [ "x86_64-linux" ];
}
