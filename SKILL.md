# nix-conf

mykey NixOS flake — T490s, greetd+ReGreet, KDE Plasma + SwayFX, Vesktop+nixcord.

## Wiring

flake-parts + import-tree — every `.nix` under `modules/` auto-included.
`configurations/<name>/` → `nixosConfigurations.<name>`.
Suffix `_x86` → `x86_64-linux`, `_aarch64` → `aarch64-linux`.

## Structure

configurations/  per-machine hardware, hostname, locale, stateVersion
modules/configurations.nix  glue: reads configurations/ → flake outputs
modules/nixos/  system modules (boot, greetd, plasma, swayfx, audio, network, stylix)
modules/home/  Home Manager modules (terminal, git, editor, nixcord, browser, gaming, tools)

## Module policy

One concern per file.
`flake.modules.nixos.<name>` — system module (imported by host)
`flake.modules.homeManager.<name>` — user module (imported by home/default.nix)

## Adding

New machine     → `mkdir configurations/<name>/` + `default.nix` + `hardware.nix`
New system svc  → `modules/nixos/<name>.nix` (auto-included, import in host)
New user pkg    → `modules/home/programs/<name>.nix` (auto-included, wire in home/default.nix)
New nixcord plugin → edit `modules/home/programs/nixcord.nix`

## Rebuild

sudo nixos-rebuild switch --flake .#nixos_x86

## Inputs

nixpkgs(unstable) home-manager nixcord stylix flake-parts import-tree
