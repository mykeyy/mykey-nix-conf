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
            DISCORD_OWNER_ID="your-personal-discord-user-id"
            
            Optional variables:
            OPENCODE_API_BASE="https://api.deepinfra.com/v1"
            OPENCODE_MODEL="deepinfra/deepseek-ai/DeepSeek-V4-Flash"
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

            # Run directly as your user to easily access the project folder
            User = "mykey";
            Group = "users";

            # Security and sandboxing
            Restart = "on-failure";
            RestartSec = "10s";
            ProtectSystem = "false";
            ProtectHome = "false";
          };
        };
      };
    };
}
