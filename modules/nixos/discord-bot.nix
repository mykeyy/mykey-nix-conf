{
  flake.modules.nixos.discord-bot = { config, lib, ... }:
    let
      cfg = config.services.discord-bot;
    in {
      options.services.discord-bot = {
        enable = lib.mkEnableOption "Rust Discord bot powered by OpenCode AI";

        secretsFile = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/discord-bot/secrets.env";
          description = ''
            Path to the environment file containing the required secrets.
            The file must contain:
            DISCORD_TOKEN="your-discord-bot-token"
            OPENCODE_API_KEY="your-opencode-go-api-key"
            
            Optional variables:
            OPENCODE_API_BASE="https://opencode.ai/zen/go/v1"
            OPENCODE_MODEL="gpt-4o"
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        systemd.services.discord-bot = {
          description = "OpenCode Rust Discord Bot Service";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            # Execute the pre-compiled binary from your project workspace
            ExecStart = "/home/mykey/Projects/discord-bot/target/release/discord-bot";
            
            # Load keys securely from the secrets file
            EnvironmentFile = cfg.secretsFile;

            # Security and sandboxing
            Restart = "on-failure";
            RestartSec = "10s";
            DynamicUser = true;
            StateDirectory = "discord-bot";
            ProtectSystem = "strict";
            ProtectHome = "read-only"; # Allow reading/executing the binary in home directory
            NoNewPrivileges = true;
          };
        };
      };
    };
}
