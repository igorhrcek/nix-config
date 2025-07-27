{pkgs, ...}: let
  user = "igor";
in {
  imports = [
    ./homebrew
  ];

  documentation = {
    enable = false;
    doc.enable = false;
    info.enable = false;
  };

  documentation.man = {
    enable = false;
  };

  environment = {
    etc."pam.d/sudo_local".text = ''
      # Managed by Nix Darwin
      auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
      auth       sufficient     pam_tid.so
    '';
  };

  environment.userLaunchAgents = {
    "com.1password.SSH_AUTH_SOCK.plist" = {
      source = pkgs.writeText "com.1password.SSH_AUTH_SOCK.plist" ''
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>com.1password.SSH_AUTH_SOCK</string>
          <key>ProgramArguments</key>
          <array>
            <string>/bin/sh</string>
            <string>-c</string>
            <string>/bin/ln -sf /Users/igor/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock $SSH_AUTH_SOCK</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
        </dict>
        </plist>
      '';
    };
  };
  system.primaryUser = "igor";

  system.defaults = {
    dock = {
      minimize-to-application = true;
      show-process-indicators = true;
      show-recents = false;
      static-only = false;
      showhidden = false;
      tilesize = 56;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
      persistent-apps = [
        "/System/Applications/Mail.app/"
        "/Applications/Bear.app/"
        "/Applications/BoltAI.app/"
        "/Applications/Things3.app/"
        "/Applications/Visual Studio Code.app/"
        "/Applications/Cursor.app/"
        "/Applications/Ghostty.app/"
        "/Applications/Medis.app/"
        "/Applications/Brave Browser.app/"
        "/Applications/Telegram.app/"
        "/Applications/WhatsApp.app/"
        "/Applications/Viber.app/"
        "/Applications/Notion.app/"
        "/Applications/Spotify.app/"
        "/Applications/Slack.app/"
        "/Applications/RapidAPI.app/"
        "/Applications/TablePlus.app/"
        "/Applications/DevUtils.app/"
        "/Applications/Fantastical.app/"
        "/System/Applications/Messages.app/"
        "/Applications/1Password.app/"
      ];
    };

    finder = {
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
      ShowStatusBar = true;
    };

    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      AppleMeasurementUnits = "Centimeters";
      InitialKeyRepeat = 30;
      KeyRepeat = 1;
      "com.apple.keyboard.fnState" = true;
      AppleShowScrollBars = "WhenScrolling";
    };

    loginwindow = {
      GuestEnabled = false;
    };

    menuExtraClock = {
      Show24Hour = false;
    };

    trackpad = {
      Clicking = true;
      Dragging = false;
      TrackpadThreeFingerDrag = false;
    };
  };

  system.defaults.CustomUserPreferences = {
    # Avoid creating .DS_Store files on network or USB volumes
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
    "com.apple.frameworks.diskimages" = {
      skip-verify = true;
      skip-verify-locked = true;
      skip-verify-remote = true;
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  environment.variables.SHELL = "${pkgs.fish}/bin/fish";

  users.users.igor = {
    home = "/Users/igor";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    users.${user} = {pkgs, ...}: {
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        stateVersion = "25.05";
      };

      imports = [
        ../shared/home-manager.nix
        ./programs/ghostty
        ./programs/1password-agent
      ];

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };
}
