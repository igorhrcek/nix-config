{...}: {
  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
      # "--disable-ctrl-r"
    ];
    settings = {
      dialect = "uk";
      style = "full"; # gives the bordered look
      invert = true; # results top-to-bottom, selector at top
      inline_height = 40;
      show_help = true;
      show_tabs = true;
      sync_address = "https://atuin.hrcek.rs";
      auto_sync = true;
      sync_frequency = "1m";
      search_mode = "fulltext"; # exact substring matching like fzf --exact
      sync = {
        records = true;
      };
      theme = {
        name = "catppuccin-frappe-blue";
      };
    };
  };
}
