{
  flake.modules.nixos.packages = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      antigravity
      wget
      vim
      opencode
      ghostty
      git
    ];
  };
}
