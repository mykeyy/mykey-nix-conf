mykey-nix-conf
==============

**T490s** — greetd+ReGreet — Plasma 6 — SwayFX — Hyprland (hy3) — Vesktop+nixcord
  *Dendritic flake-parts · rose-pine themed · one command to rebuild everything*


About
-----

My personal NixOS configuration for my daily-driver ThinkPad T490s.
It started as a simple setup and evolved into a clean, modular flake
borrowing the **flat leaf style** from `invra/inc`_ and the **dendritic
pattern** from `mightyiam/infra`_, auto-imported with `import-tree`_.

If my machine ever breaks, a single command restores everything::

   sudo nixos-rebuild switch --flake ~/.nix#tp490s


Structure
---------

::

   ├── configurations/tp490s/    one host
   ├── modules/
   │   ├── nixos/                 system modules (greetd, stylix, swayfx, hyprland...)
   │   ├── home/                  home-manager leaf modules (_shell, _bar, _sway...)
   │   └── docs/                  reStructuredText docs
   ├── configs/                   eww, kanshi, starship, scripts
   └── wallpapers/


Sessions
--------

======= ===========================================
SwayFX   Blur, shadows, rounded corners, eww bar
Hyprland hy3 tabbed layout (inspired by mightyiam)
Plasma 6 Full KDE desktop, rose-pine themed
======= ===========================================


Links
-----

* `Documentation (SKILL.md) <./SKILL.md>`_
* `invra/inc <https://github.com/invra/inc>`_ — module style inspiration
* `mightyiam/infra <https://github.com/mightyiam/infra>`_ — dendritic pattern origin
* `import-tree <https://github.com/denful/import-tree>`_ — auto-import engine


.. _invra/inc: https://github.com/invra/inc
.. _mightyiam/infra: https://github.com/mightyiam/infra
.. _import-tree: https://github.com/denful/import-tree
