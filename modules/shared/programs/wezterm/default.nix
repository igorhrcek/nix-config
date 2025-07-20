{
#   catppuccin = {
#     wezterm = {
#       enable = true;
#     };
#   };

  programs.wezterm = {
    enable = true;

    settings = {
      font_size = 16.0;
      line_height = 1.1;
      cell_width = 1.0;
      font = "TX02 Nerd Font ExtraCondensed SemiLight";
      color_scheme = "Dracula";
      window_decoration = "RESIZE";
      enable_tab_bar = true;
      tab_bar_at_bottom = false;
      use_fancy_tab_bar = true;
      tab_max_width = 30;
      window_padding = {
        left = 10;
        right = 10;
        top = 10;
        bottom = 10;
      };
      window_background_opacity = 0.9;
      front_end = "WebGpu";
      scrollback_lines = 10000;

      colors = {
        tab_bar = {
          background = "#171720";
          inactive_tab = {
            bg_color = "#2B2B41";
            fg_color = "#808080";
          };
          new_tab = {
            bg_color = "#171720";
            fg_color = "#808080";
          };
        };
      };

      mux_env_remove = [
        "SSH_CLIENT"
        "SSH_CONNECTION"
      ];

      act = {
        SpawnCommandInNewTab = {
            cwd = weztern.home_directory;
        };
      };

      leader = {
        key = "Space";
        mods = "CTRL";
        timeout_milliseconds = 3000;
      };

      keys = [
        {
          key = "d";
          mods = "CTRL|ALT|SHIFT";
          action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" });
        }
        {
          key = "k";
          mods = "CMD";
          action = act.ClearScrollback "ScrollbackAndViewport";
        }
        {
          key = "d";
          mods = "CTRL|SHIFT";
          action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" });
        }
        {
          key = "w";
          mods = "CTRL|SHIFT";
          action = wezterm.action.CloseCurrentPane { confirm = false };
        }
        {
          key = "w";
          mods = "CMD";
          action = wezterm.action.CloseCurrentTab { confirm = false };
        }
        {
          key = "LeftArrow";
          mods = "LEADER";
          action = wezterm.action.ActivateTabRelative(-1);
        }
        {
          key = "RightArrow";
          mods = "LEADER";
          action = wezterm.action.ActivateTabRelative(1);
        }
        { 
          key = "LeftArrow"; 
          mods = "OPT"; 
          action = wezterm.action({ SendString = "\x1bb" });
        }
        { 
          key = "RightArrow";
          mods = "OPT";
          action = wezterm.action({ SendString = "\x1bf"});
        }
        {
          key = "r";
          mods = "LEADER";
          action = act.ActivateKeyTable({
                  name = "resize_pane";
                  one_shot = false;
          });
        }
        {
          key = "a";
          mods = "LEADER";
          action = act.ActivateKeyTable({
                  name = "activate_pane";
                  timeout_milliseconds = 1000;
          });
        }
      ];
    };
  };
}