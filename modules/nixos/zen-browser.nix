{ inputs, ... }:
{
  flake.modules.nixos.zen-browser = { pkgs, ... }: {
    environment.systemPackages = [
      (pkgs.wrapFirefox inputs.zen-browser.packages.x86_64-linux.zen-browser-unwrapped {
        extraPrefs = ''
          lockPref("extensions.autoDisableScopes", 0);
        '';

        extraPolicies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;

          ExtensionSettings = {
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "normal_installed";
            };
          };

          SearchEngines = {
            Default = "DuckDuckGo";
            Add = [
              {
                Name = "Nixpkgs Packages";
                URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                IconURL = "https://nixos.wiki/favicon.ico";
                Alias = "@np";
              }
              {
                Name = "NixOS Options";
                URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
                IconURL = "https://nixos.wiki/favicon.ico";
                Alias = "@no";
              }
            ];
          };
        };
      })
    ];
  };
}
