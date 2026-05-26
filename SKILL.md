# mykey-nix-conf 🌸

> T490s · greetd+ReGreet · SwayFX · Hyprland (dwindle, Intel-tuned) · Plasma 6 · Discord+Vencord (nixcord)  
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
| [**vic/import-tree**](https://github.com/vic/import-tree) | Auto-import engine, recursive `.nix` discovery |

---

## Structure

```
├── configurations/tp490s/        one host per folder
│   ├── default.nix               defines configurations.tp490s.module, imports leaf modules
│   └── _hardware.nix             kernel modules, filesystems, swap, Intel microcode
│
├── modules/
│   ├── configurations.nix        glue → nixosConfigurations + homeConfigurations
│   ├── systems.nix               sets systems = [ "x86_64-linux" ], declares flake.modules option
│   ├── nixpkgs.nix               perSystem pkgs with allowUnfree
│   ├── nixos/                    system modules (one concern per file)
│   │   ├── base.nix              boot, nix settings, GC, bluetooth, home-manager glue
│   │   ├── greetd.nix            regreet with cage
│   │   ├── stylix.nix            rose-pine theming engine + Apple Color Emoji
│   │   ├── audio.nix             pipewire + rtkit
│   │   ├── network.nix           networkmanager, openssh, tailscale, firewall
│   │   ├── hardware-acceleration.nix  Intel VA-API + VDPAU drivers
│   │   ├── hyprland.nix          Hyprland system support + UWSM + ozone
│   │   ├── swayfx.nix            swayfx + libinput
│   │   ├── plasma.nix            Plasma 6 + KDE Connect + kwallet PAM
│   │   ├── packages.nix          system packages + opencode overlay
│   │   ├── zen-browser.nix       Zen browser wrapped with policies + uBlock
│   │   └── printing.nix          CUPS printing
│   ├── home/                     home-manager modules
│   │   ├── default.nix           imports all _* sub-modules, nixcord config
│   │   ├── _core.nix             username, homeDirectory, stateVersion
│   │   ├── _shell.nix            nushell · starship · carapace · zoxide · fastfetch
│   │   ├── _terminal.nix         ghostty (rose-pine, 95% opacity)
│   │   ├── _bar.nix              eww status bar (scss inline, yuck from configs/)
│   │   ├── _launcher.nix         tofi (fullscreen rose-pine style)
│   │   ├── _mako.nix             mako notifications
│   │   ├── _hyprland.nix         dwindle layout, Intel-tuned effects, keybinds
│   │   ├── _hyprpaper.nix        forcefully disables hyprpaper service
│   │   ├── _sway.nix             swayfx with blur + shadows
│   │   ├── _packages.nix         user packages + screenshot tool + power-menu + annotate scripts
│   │   ├── _apps.nix             bat, ripgrep, btop, git, helix, vscodium
│   │   ├── _clipboard.nix        cliphist
│   │   ├── _spotify.nix          spotify-player TUI (rose-pine, 320kbps)
│   │   └── _theme.nix            plasma config files + ghostty theme
│   └── docs/
│       └── README.rst             reStructuredText documentation
│
├── configs/                       static config files
│   ├── eww/eww.yuck              bar widget definitions
│   ├── scripts/                   shell scripts
│   ├── starship.toml              starship prompt config
│   ├── ghostty-rose-pine          ghostty theme file
│   ├── kanshi                     display profile config
│   ├── spotify-player-theme.toml  spotify-player theme
│   ├── fastfetch-logo.png         custom fastfetch logo
│   ├── kglobalshortcutsrc         KDE shortcuts
│   ├── kwinrc                     KWin config
│   ├── plasmashellrc              Plasma shell config
│   ├── plasmarc                   Plasma config
│   ├── plasma-localerc            Plasma locale
│   ├── plasma-org.kde.plasma.desktop-appletsrc  Plasma applets
│   └── oh-my-posh.json           (unused, legacy)
│
├── tools/
│   └── screenshot/                Zig screenshot helper built by Nix (zig_0_15)
│
├── wallpapers/                    wallpaper images
├── quickcss.nix                   Rose Pine CSS for Discord/Vencord (despite .nix extension, it's CSS)
├── flake.nix                      flake entry point
├── flake.lock                     pinned inputs
└── README.rst                     project readme
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
| **Chat** | Discord + Vencord via nixcord (vesktop is disabled) |
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
| `zen-browser` | Web browser |
| `opencode` | AI coding assistant |

---

## Known Issues & Bugs 🐛

> Things that should be fixed or investigated. Ordered by severity.

### 🔴 Critical / Will break on update

1. **`explicit_sync` is deprecated and removed in Hyprland ≥ v0.50**  
   `_hyprland.nix` sets `render.explicit_sync = 0` and `render.explicit_sync_kms = 0`.
   These options no longer exist — Hyprland now handles explicit sync automatically.
   On newer Hyprland versions this will produce a config error or be silently ignored.
   **Fix:** Remove the entire `render` block from `_hyprland.nix`.

2. **`withUWSM = false` in `hyprland.nix` goes against upstream recommendation**  
   Hyprland upstream now recommends launching via UWSM (Universal Wayland Session
   Manager) for proper systemd integration. Keeping this `false` means environment
   variables and session lifecycle aren't managed as cleanly.
   **Fix:** Set `withUWSM = true` or remove the line (defaults to `true` on newer nixpkgs).

3. **Dual stylix module import creates potential conflict**  
   `stylix.nixosModules.stylix` is imported in `modules/nixos/stylix.nix`, AND
   `stylix.homeModules.stylix` is imported in `modules/configurations.nix` for the
   standalone `homeConfigurations`. Meanwhile, `base.nix` also enables
   `home-manager` as a NixOS module with `useGlobalPkgs = true`. This means the NixOS
   stylix module already propagates to home-manager users via the NixOS integration,
   but the standalone `homeConfigurations.mykey` separately imports the HM module.
   If you ever try to use the standalone HM config, you may get option conflicts
   or doubled theming.
   **Fix:** Decide whether you use the NixOS-integrated HM or standalone HM, not both.

### 🟡 Medium / Incorrect or stale

4. **`quickcss.nix` is not actually Nix — it's CSS**  
   The file `quickcss.nix` contains pure CSS (Rose Pine theme for Discord). The `.nix`
   extension is misleading. It works because `builtins.readFile` just reads raw text,
   but it confuses editors, linters, and anyone reading the repo.
   **Fix:** Rename to `quickcss.css` and update the `builtins.readFile` path in
   `modules/home/default.nix`.

5. **Duplicate `nixpkgs` import — `configurations.nix` re-imports nixpkgs**  
   `configurations.nix` does `pkgs = import inputs.nixpkgs { ... }` which creates a
   separate nixpkgs instance. Meanwhile `modules/nixpkgs.nix` also creates a perSystem
   `pkgs`. The NixOS module already has its own `nixpkgs.pkgs` assignment. This means
   there are potentially 3 separate nixpkgs evaluations happening.
   **Fix:** Consider using a single pkgs instance. The NixOS one is already handled,
   but the standalone HM config could use `nixpkgs.legacyPackages.${system}` instead.

6. **Duplicate shell alias — `fuckoff` defined in two places**  
   `_core.nix` defines `home.shellAliases.fuckoff = "exit"` and `_shell.nix` defines
   `programs.nushell.shellAliases.fuckoff = "exit"`. The `home.shellAliases` one
   applies to all shells, the nushell one only to nushell. Both set the same value
   for the same alias — one of them is redundant.
   **Fix:** Remove from `_core.nix` since nushell is your only shell, or remove from
   `_shell.nix` since `home.shellAliases` already covers it.

7. **Duplicate `spotify` alias in nushell**  
   `_shell.nix` defines `spotify = "spotify_player"` but spotify is also in
   `home.packages` as the full Spotify desktop client. This means the `spotify` command
   will always run the TUI, not the GUI — which may be intentional but is confusing.
   **Clarify:** If you always use the TUI, consider not installing the GUI `spotify`
   package to save closure size.

8. **Missing `power.nix` — SKILL.md references power module but it doesn't exist**  
   The old SKILL.md mentioned `power.nix` (power profiles daemon) but there's no such
   file in `modules/nixos/`. The `power-profiles-daemon` service isn't enabled anywhere
   in the config, yet the eww bar widget references power profiles (`PERF`/`BAL`/`SAV`).
   **Fix:** Either create `modules/nixos/power.nix` with
   `services.power-profiles-daemon.enable = true;` or remove the power profile
   references from the eww bar.

9. **`import-tree` reference in SKILL.md points to wrong repo**  
   The Inspiration table links to `denful/import-tree` but your `flake.nix` actually
   uses `github:vic/import-tree`. These are the same project (vic is the original
   author, denful is the org), but the link should match what's in `flake.nix` for
   consistency.
   **Fix:** Update the link to `github.com/vic/import-tree` to match your flake input.

10. **README.rst says Hyprland uses "hy3" layout but config uses "dwindle"**  
    `README.rst` line 40 says "hy3 tabbed layout (inspired by mightyiam)" but
    `_hyprland.nix` sets `layout = "dwindle"`. The hy3 plugin isn't configured anywhere.
    **Fix:** Update README.rst to say "dwindle" or actually add hy3 if that was the plan.

11. **Stale vesktop window rules in `_hyprland.nix`**  
    `windowrulev2` includes `opacity 0.85 0.75,class:^(vesktop)$` but nixcord
    has `vesktop.enable = false` — you're using standard Discord with Vencord.
    The vesktop rule will never match anything.
    **Fix:** Remove the vesktop window rule, or change it to match the actual
    Discord window class if you want opacity on Discord.

### 🟢 Low / Cosmetic & cleanup

12. **`oh-my-posh.json` in configs/ appears unused**  
    No module references this file. It seems like a leftover from before switching to
    starship.
    **Fix:** Delete `configs/oh-my-posh.json`.

13. **Ghostty installed at both system and home level**  
    `modules/nixos/packages.nix` installs `ghostty` system-wide and
    `modules/home/_terminal.nix` enables `programs.ghostty`. The HM module wraps
    ghostty with config, so the system-level package is redundant.
    **Fix:** Remove `ghostty` from `modules/nixos/packages.nix`.

14. **`antigravity` installed at both system and user level**  
    Present in both `modules/nixos/packages.nix` and `modules/home/_packages.nix`.
    **Fix:** Pick one location.

15. **Several home packages are also installed via `programs.*` modules**  
    `bat`, `ripgrep` appear in both `_packages.nix` (via `with pkgs`) and `_apps.nix`
    (via `programs.bat.enable`, `programs.ripgrep.enable`). The `programs.*` modules
    already handle installation.
    **Fix:** Remove `bat` and `ripgrep` from `_packages.nix` since they're enabled
    via `programs.*` in `_apps.nix`.

16. **`wget` installed at both system and home level**  
    Present in `modules/nixos/packages.nix` and `modules/home/_packages.nix`.
    **Fix:** Keep only in one place (system is sufficient).

17. **Unused `pkgs` argument in several modules**  
    `_clipboard.nix` takes `{ pkgs, ... }:` but doesn't use `pkgs`.
    `_core.nix` takes `{ pkgs, ... }:` but doesn't use `pkgs`.
    **Fix:** Change to `{ ... }:`.

18. **`checkConfig = false` in Sway module may hide errors**  
    `_sway.nix` disables config checking. This was likely needed for SwayFX-specific
    options, but it means typos in keybinds won't be caught at build time.
    **Note:** This is a known trade-off with SwayFX, not necessarily a bug.

19. **Hyprland `exec-once` uses `swaybg` instead of `hyprpaper`**  
    `_hyprland.nix` starts `swaybg` for wallpapers, and `_hyprpaper.nix` forcefully
    disables hyprpaper. Hyprland's native `hyprpaper` is more efficient. The hacky
    service disable via `ConditionPathExists = "/nonexistent"` is fragile.
    **Consider:** Using `hyprpaper` natively or at least documenting why `swaybg` is preferred.

---

## Improvement Ideas 💡

> Things that aren't broken but could be better.

### Architecture

- **Consider `nixConfig.abort-on-warn = true`** in `flake.nix` (borrowed from
  mightyiam/infra) to catch evaluation warnings early.
- **Add `nix flake check` to your workflow** — currently no checks are defined.
  Even a basic `nixosConfigurations.tp490s.config.system.build.toplevel` check helps.
- **Consider adding a `devShell`** with formatting tools (nixfmt, statix, deadnix)
  for contributors or your own linting workflow.

### Code Quality

- **Run `deadnix`** to find unused variables and dead code across all modules.
- **Run `statix`** to catch anti-patterns in Nix code.
- **Consider `nixfmt-rfc-style`** for consistent formatting across all `.nix` files.

### Security & Hardening

- **Enable `doas` or keep `sudo`** — currently relying on default sudo. Consider
  `security.doas` for a simpler, more auditable alternative.
- **SSH hardening** — `services.openssh` is enabled but no `PasswordAuthentication`
  or `PermitRootLogin` settings are explicitly set. Consider hardening.
- **Firewall** — ports 1714/1764 (KDE Connect) are open. If you don't use KDE
  Connect on all networks, consider conditional rules or removing them.

### Performance

- **Reduce closure size** — audit `home.packages` for packages you no longer use.
  `xclip` is X11-only and may be unnecessary on a pure Wayland setup.
  `spicetify-cli` may be unused if you don't modify the Spotify GUI.
  `nodejs` and `bun` should be in project-level `devShells`, not globally.
- **Binary cache** — consider Cachix for custom packages like the screenshot tool
  to avoid rebuilding from source.

### Missing Features

- **No screen locker timeout** — `swaylock` is only triggered manually. Consider
  `swayidle` or `hypridle` for automatic locking after inactivity.
- **No backup/restore documentation** — the SKILL.md says "rebuild everything with
  one command" but doesn't mention that user data, browser profiles, etc. aren't
  covered by Nix.
- **No notification daemon for Hyprland** — mako is configured in `_mako.nix` but
  it's not started via `exec-once` in `_hyprland.nix`. Home-manager's
  `services.mako.enable` should auto-start it via systemd, but verify it works.

---

## Coding Conventions 📝

> Patterns established in this config that should be followed.

### Module patterns

- **NixOS modules** live in `modules/nixos/` and register themselves as
  `flake.modules.nixos.<name>`. They are auto-imported by import-tree.
- **Home-manager modules** live in `modules/home/` with `_` prefix. They use the
  standard HM module signature `{ pkgs, ... }:` and are manually imported by
  `modules/home/default.nix`.
- **One concern per file** — each module handles exactly one topic.
- **Static config files** go in `configs/` and are referenced with relative paths
  like `../../configs/starship.toml`.

### Naming

- System modules: `modules/nixos/<concern>.nix` (no prefix)
- Home modules: `modules/home/_<concern>.nix` (underscore prefix)
- Host configs: `configurations/<hostname>/default.nix`
- Hardware: `configurations/<hostname>/_hardware.nix`

### Style

- Use `with pkgs;` sparingly — only in `home.packages` lists
- Prefer `programs.<name>.enable = true` over raw package installation
- Use `builtins.readFile` for external config files
- Wallpaper references use Nix path literals: `../../wallpapers/wallpaper.jpg`
- Rose-pine color palette used throughout: `#191724`, `#e0def4`, `#ebbcba`, `#c4a7e7`, `#9ccfd8`, `#eb6f92`
- Stylix targets are explicitly disabled when custom theming is preferred:
  `stylix.targets.<name>.enable = false`

---

## Quick Reference

```
# Common rebuild commands
rebuild              # nushell alias → full nixos-rebuild switch
rebuild --update     # update flake inputs first
nh os switch ~/.nix  # alternative system rebuild
nh home switch ~/.nix  # home-manager only (faster)

# Debug a failing rebuild
sudo nixos-rebuild switch --flake ~/.nix#tp490s --show-trace -L -v

# Check what would change
nixos-rebuild dry-activate --flake ~/.nix#tp490s

# Update a single input
nix flake update home-manager --flake ~/.nix

# Garbage collect old generations
sudo nix-collect-garbage -d
```
