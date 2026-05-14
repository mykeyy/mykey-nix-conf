{
  flake.modules.nixos.packages = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      wget
      vim
      opencode
      ghostty
      git
    ];
  };
}
