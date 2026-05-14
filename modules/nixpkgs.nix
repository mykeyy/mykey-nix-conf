{
  lib,
  config,
  inputs,
  ...
}:
{
  options.nixpkgs.config.allowUnfree = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };

  config.perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
}
