mykey's NixOS Configuration
===========================
Dendritic NixOS flake for T490s, using flake-parts + import-tree.

Sessions: greetd+regreet, Plasma 6, SwayFX, Hyprland (hy3).

Features
--------

Shell & Terminal
~~~~~~~~~~~~~~~~
* nushell with carapace, zoxide, fastfetch
* ghostty with rose-pine theme
* starship prompt

Desktop
~~~~~~~
* greetd + regreet display manager with stylix rose-pine theme
* eww bar with workspaces, volume, music, battery, clock
* mako notifications
* tofi launcher + power menu
* cliphist clipboard history

Window Managers
~~~~~~~~~~~~~~~
* SwayFX — blur, shadows, rounded corners, eww bar
* Hyprland — hy3 layout (tabbed groups), animations
* Plasma 6 — KDE desktop session

Apps
~~~~
* Discord via Vesktop + nixcord (Vencord mods)
* Spotify (official) + spicetify-cli
* VSCodium, Helix editor
* Nixcord plugins: ClearURLs, Spotify controls
* spotify-player (terminal client)

Audio
~~~~~
* PipeWire with easyeffects (mic EQ, bass boost, noise reduction)
* calf plugins, LSP plugins

Networking
~~~~~~~~~~
* Tailscale + tailscale-systray
* NetworkManager
* OpenSSH

Multi-monitor
~~~~~~~~~~~~~
* kanshi auto-profile switching
* wdisplays GUI for display settings
* Win+P keybind support

Rebuild
-------
.. code:: bash

    sudo nixos-rebuild switch --flake ~/.nix#tp490s

Or with the nushell alias:
.. code:: bash

    rebuild
    rebuild --update  # update flake inputs first

Credits
-------
Inspired by mightyiam/infra (dendritic pattern) and invra/inc (module style).
