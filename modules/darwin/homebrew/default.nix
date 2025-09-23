{config, ...}: {
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;

    taps = builtins.attrNames config.nix-homebrew.taps;
    brews = [
      "atuin"
      "esphome"
    ];

    casks = [
      "alfred"
      "1password"
      "affinity-designer"
      "affinity-photo"
      "balenaetcher"
      "boltai"
      "brave-browser"
      "bambu-studio"
      "bettertouchtool"
      "burp-suite"
      "espanso"
      "calibre"
      "cleanshot"
      "cloudflare-warp"
      "cryptomator"
      "cursor"
      "daisydisk"
      "devutils"
      "discord"
      "fantastical"
      "firefox"
      "forklift"
      "gpg-suite"
      "gitify"
      "ghostty"
      "iina"
      "intellij-idea"
      "insta360-link-controller"
      "jordanbaird-ice"
      "keycastr"
      "little-snitch"
      "lm-studio"
      "medis"
      "numi"
      "orbstack"
      "oscar"
      "protonvpn"
      "proxyman"
      "rapidapi"
      "raycast"
      "rectangle-pro"
      "rocket"
      "runjs"
      "slack"
      "syntax-highlight"
      "spotify"
      "stats"
      "the-unarchiver"
      "tableplus"
      "viber"
      "visual-studio-code"
      "vlc"
      "whatsapp"
      "yubico-yubikey-manager"
      "zed"
      "zoom"
      "wezterm"
    ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "Anybox" = 1593408455;
      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Pixelmator Pro" = 1289583905;
      "Telegram" = 747648890;
      "Things" = 904280696;
    };
  };
}
