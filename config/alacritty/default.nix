{ config, ... }:
let
  colors = config.colorScheme.colors;
in {
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };

      window = {
        padding = {
          x = 2.0;
          y = 2.0;
        };
        opacity = 1.0;
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      
      selection = {
        save_to_clipboard = false;
      };

      font = {
        size = 12.0;
        draw_bold_text_with_bright_colors = false;
        normal = {
          family = "FiraCode Nerd Font";
          style = "Light";
        };
        bold = {
          family = "FiraCode Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "FiraCode Nerd Font";
          style = "Light";
        };
        bold_italic = {
          family = "FiraCode Nerd Font";
          style = "Light";
        };
        glyph_offset = {
          x = 0.0;
          y = 0.0;
        };
      };

      colors = {
        primary = { 
          background = "#1d2225";
          /* foreground = "#${colors.base00}"; */ 
        };
        cursor = {};
        vi_mode_cursor = {};
        line_indicator = {};
        footer_bar = {};
        selection = {};
        search = {};
        hints = {};
        normal = {};
        bright = {};
        dim = {};
      };

      bell = {};
    };
  };
}
