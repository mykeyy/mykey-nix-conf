# mykey-nix-conf 🌸

> T490s · greetd+ReGreet · SwayFX · Hyprland (dwindle, Intel-tuned) · Plasma 6 · Vesktop+nixcord  
> *Nix + Zig + Rust · dendritic flake-parts with rose-pine aesthetics*

---

## About

This is my personal NixOS configuration for my laptop — the one I use every day.
It started as a much simpler config and gradually iterated into something cleaner,
borrowing the module style from my friend's [invra/inc](https://github.com/invra/inc)
and the dendritic pattern from [mightyiam/infra](https://github.com/mightyiam/infra).

It's simple, not over-engineered — just the things I need, all in one place. If my
machine ever breaks, I can rebuild everything with one command. No manual setup,
no reinstalling apps one by one.

I've been on NixOS since around March or April 2025. Before that, I was tired of
watching Windows slow down with every update and having to start over from scratch.
Now everything I need is declarative — a single `sudo nixos-rebuild switch` for
system changes or a faster `nh home switch` for user changes, and I'm back where
I left off.

I prefer keeping the maintained code surface small: Nix for declarative system
and home configuration, Zig/Rust for custom tooling, and only minimal external
config formats when a program requires them.

This config should take about 5 to 10 minutes to read through. Nothing complicated,
just a student setup that works well on a ThinkPad T490s. Feel free to use it as
a reference for your own setup.

---

## Inspiration

Inspired by and borrowing patterns from:

| Repo | Pattern |
|------|---------|
| [**invra/inc**](https://github.com/invra/inc) | Flat leaf modules, `facter.json`, reStructuredText docs |
| [**mightyiam/infra**](https://github.com/mightyiam/infra) | Dendritic pattern origin, import-tree, `_` sub-modules |
| [**denful/import-tree**](https://github.com/denful/import-tree) | Auto-import engine, recursive `.nix` discovery |

---

## Structure

```
├── configurations/tp490s/    one host per folder
│   ├── default.nix           imports leaf modules
│   └── _hardware.nix         kernel, filesystems, swap

├── modules/
│   ├── configurations.nix     glue → nixosConfigurations + homeConfigurations
│   ├── nixos/                 system modules (one concern per file)
│   │   ├── greetd.nix         regreet with rose-pine
│   │   ├── stylix.nix         theming engine
│   │   ├── power.nix          power profiles daemon
│   │   ├── hyprland.nix       Hyprland system support
│   │   └── ...                swayfx, hyprland, plasma, etc.
│   ├── home/                  home-manager modules
│   │   ├── default.nix        imports all _* sub-modules
│   │   ├── _shell.nix         nushell · starship · fastfetch
│   │   ├── _bar.nix           eww status bar
│   │   ├── _hyprland.nix      dwindle layout, Intel-tuned effects
│   │   ├── _sway.nix          swayfx with blur + shadows
│   │   └── ...                one file = one concern
│   └── docs/
│       └── README.rst         reStructuredText documentation

├── tools/
│   └── screenshot/            Zig screenshot helper built by Nix
```

### Why `_` prefixed files?

> *"Nix files prefixed with an underscore are ignored"*  
> — [mightyiam/infra](https://github.com/mightyiam/infra)

`import-tree` auto-loads ALL `.nix` files as flake modules. Home-manager sub-modules
need `pkgs`/`config` which aren't available in the flake context. The `_` prefix
tells import-tree: *"skip this file, it's imported manually by `default.nix`."*

---

## Sessions

| Session | Keybind highlight |
|---------|-------------------|
| **SwayFX** | `Mod4+Shift+E` power menu · `Mod4+L` lock · `Mod4+P` display settings |
| **Hyprland** | Intel-tuned blur/shadows · dwindle layout · `Mod4+HJKL` navigate |
| **Plasma 6** | Full KDE desktop with rose-pine Qt theme |

---

## Keybinds

| Key | Action |
|-----|--------|
| `Mod4+Shift+E` | Power menu (lock, logout, restart, shutdown) |
| `Mod4+L` | Lock screen |
| `Mod4+P` | Display settings (wdisplays) |
| `Mod4+Return` | Ghostty terminal |
| `Alt+Space` | Tofi app launcher |
| `Alt+S` | Screenshot (region) |
| `Alt+V` | Clipboard history through cliphist + tofi |
| `Alt+1-5` | Switch workspace |
| `Alt+Shift+1-5` | Move window to workspace |
| `XF86Audio*` | Volume and media controls |
| `XF86MonBrightness*` | Brightness controls |

---

## Packages

| Category | What |
|----------|------|
| **Shell** | nushell · starship · carapace · zoxide · fastfetch |
| **Terminal** | ghostty (rose-pine) |
| **Bar** | eww (workspaces, music, volume, RAM, battery, clock, power profile) |
| **Launcher** | tofi |
| **Browser** | zen-browser |
| **Chat** | vesktop + nixcord (Vencord mods) |
| **Music** | spotify + spicetify-cli + spotify-player (TUI) |
| **Editor** | helix · vscodium |
| **Gaming** | prismlauncher · Moonlight (remote from Windows) |
| **Power** | power-profiles-daemon · `PERF`/`BAL`/`SAV` eww widget |
| **Audio** | easyeffects (mic EQ) · pipewire |
| **Clipboard** | cliphist · wl-clipboard sync |
| **Fonts** | JetBrainsMono Nerd Font · noto-fonts (CJK fallback) |
| **Custom tools** | Zig screenshot helper built by Nix |

---

## Languages

| Language | Used for |
|----------|----------|
| **Nix** | System, home-manager, packages, services, program configuration |
| **Zig** | Small fast desktop helpers like `screenshot` |
| **Rust** | Additional performance-oriented tools when needed |

---

## Rebuild

```bash
# Full system rebuild
sudo nixos-rebuild switch --flake ~/.nix#tp490s

# Faster system rebuild helper
nh os switch ~/.nix

# Home-manager only; use this for most user-level edits
nh home switch ~/.nix

# With nushell alias
rebuild
rebuild --update   # update flake inputs first
```

---

## Inputs

| Input | Purpose |
|-------|---------|
| `nixpkgs/unstable` | Package set |
| `home-manager` | User environment |
| `nixcord` | Discord + Vencord |
| `stylix` | Rose-pine theming |
| `flake-parts` | Flake framework |
| `import-tree` | Dendritic auto-import |
| `zen-browser` | Web browser
