{
  lib,
  config,
  inputs,
  ...
}:
let
  mkNixosConfig =
    name: cfg:
    let
      system =
        if lib.hasSuffix "x86" name then "x86_64-linux"
        else if lib.hasSuffix "aarch64" name then "aarch64-linux"
        else if lib.hasPrefix "mac" name then "aarch64-darwin"
        else "x86_64-linux";
      isLinux = lib.hasSuffix "linux" system;
    in
    {
      nixosConfigurations = lib.optionalAttrs isLinux {
        "${name}" = lib.nixosSystem {
          inherit system;
          modules = [
            {
              nixpkgs.pkgs = import inputs.nixpkgs {
                inherit system;
                config.allowUnfree = true;
              };
            }
            cfg.module
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
in
{
  options.configurations = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
  };

  config.flake = lib.foldl' lib.recursiveUpdate { } (
    lib.mapAttrsToList (
      name: cfg: mkNixosConfig name cfg
    ) config.configurations
  );
}
