# mykey-nix-conf

mykey NixOS flake — T490s, greetd+ReGreet, KDE Plasma + SwayFX, Vesktop+nixcord.

## Wiring

flake-parts + import-tree — every `.nix` under `modules/` auto-included.
`configurations/<name>/` → `nixosConfigurations.<name>`.

## Structure

configurations/  per-machine hardware, hostname, locale, stateVersion
modules/configurations.nix  glue: reads configurations/ → flake outputs
modules/nixos/  system modules (boot, greetd, plasma, swayfx, audio, network, stylix)
modules/home/  Home Manager modules

## Module policy

One concern per file.
`flake.modules.nixos.<name>` — system module (imported by host)
`flake.modules.homeManager.base` — user module

## Adding

New machine     → `mkdir configurations/<name>/` + `default.nix` + `hardware.nix`
New system svc  → `modules/nixos/<name>.nix` (auto-included, import in host)
New user pkg    → add to `modules/home/default.nix`
New nixcord plugin → edit nixcord config in `modules/home/default.nix`

## Rebuild

sudo nixos-rebuild switch --flake .#tp490s

## Inputs

nixpkgs(unstable) home-manager nixcord stylix flake-parts import-tree
