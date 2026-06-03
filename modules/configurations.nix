{
  lib,
  config,
  inputs,
  rootPath,
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
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = lib.optionalAttrs isLinux {
        "${name}" = lib.nixosSystem {
          inherit system;
          modules = [
            {
              nixpkgs.pkgs = pkgs;
            }
            cfg.module
          ];
          specialArgs = { inherit inputs; };
        };
      };

      homeConfigurations = lib.optionalAttrs isLinux {
        mykey = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            config.flake.modules.homeManager.base
          ];
          extraSpecialArgs = { inherit inputs rootPath; };
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
