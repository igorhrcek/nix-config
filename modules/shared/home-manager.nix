{...}: {
  imports = [
    ./programs/atuin
    ./programs/bat
    ./programs/btop
    ./programs/direnv
    ./programs/doggo
    ./programs/fish
    ./programs/git
    ./programs/k9s
    ./programs/krew
    ./programs/lsd
    ./programs/lazygit
    # ./programs/neovim
    ./programs/starship
    ./programs/zoxide
  ];

  # Silence catppuccin auto-enroll deprecation warning. autoEnable=false keeps
  # per-program enables manual (current behavior); enable=true is the new global toggle.
  catppuccin = {
    enable = true;
    autoEnable = false;
  };
}
