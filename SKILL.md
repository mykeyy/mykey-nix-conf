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
│   └── plasma-org.kde.plasma.desktop-appletsrc  Plasma applets
│
├── tools/
│   └── screenshot/                Zig screenshot helper built by Nix (zig_0_15)
│
├── wallpapers/                    wallpaper images
├── quickcss.nix                   Rose Pine CSS for Discord/Vencord (read as raw text via builtins.readFile)
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
| **Power** | battery percentage in eww bar · manual power profile switching |
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

# With nushell aliases
rebuild          # full nixos-rebuild switch
rebuild --update # update flake inputs first
hms              # home-manager only (faster, no sudo)
hms --update     # update flake inputs then home switch
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
| `spicetify-nix` | Spicetify themes + extensions |


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

- Only Nix, Zig, and Rust — **no other languages** (no CSS/SCSS/JSON/YAML files).
  Config data that would normally be CSS/JSON is kept in `.nix` files and read via
  `builtins.readFile` or inline strings.
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
hms                  # nushell alias → nh home switch (no sudo, faster)
hms --update         # update flake inputs then home switch
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

---

## Aider Chat Cheat Sheet 🤖

### 1. Launching Aider
Launch it from the root of your repository. It automatically reads your `.gitignore` and stages edits inside Git.

```bash
# Recommended: Use Claude 3.5 Sonnet (requires ANTHROPIC_API_KEY)
export ANTHROPIC_API_KEY="your-key-here"
aider

# Alternative: Use Gemini 1.5 Pro/Flash (requires GEMINI_API_KEY)
export GEMINI_API_KEY="your-key-here"
aider --model gemini/gemini-1.5-pro

# Alternative: Use DeepSeek (requires DEEPSEEK_API_KEY)
export DEEPSEEK_API_KEY="your-key-here"
aider --model deepseek/deepseek-chat
```

### 2. Core Commands inside Chat
Inside the aider shell, you can use these easy `/` commands to coordinate:

*   `/add <file>` — Add a file to the active chat session (giving the LLM write access).
*   `/drop <file>` — Remove a file from the active chat session (reduces token usage).
*   `/git <cmd>` — Run standard git commands directly from Aider (e.g., `/git status`, `/git diff`).
*   `/test <cmd>` — Run a command (like `nix build`) to verify changes; if it fails, Aider automatically gets the errors and tries to fix them!
*   `/undo` — Revert the last commit made by Aider if you don't like the changes.
*   `/exit` — Exit the Aider session.

### 3. Best Practices
- **Commit History:** Aider will automatically commit every successfully completed file edit with a descriptive, atomic commit message. If you want to group edits yourself, you can run Aider with `aider --no-auto-commit`.
- **Repo Map:** Aider maintains a local tree-sitter map of your repository. It understands your codebase's structure even if you only `/add` one or two files!
- **Interactive Editing:** Simply tell Aider: *"Change the ghostty font size to 16 in _terminal.nix"* or *"Refactor packages.nix to remove duplicate packages"*, and watch it write the precise diff and commit it.

