{ config, lib, pkgs, ...}:
let
  c = config.colorScheme.colors;
  tmuxFzfPath = pkgs.tmuxPlugins.tmux-fzf.out;
  # TODO remove this, move scripts to bin and call every script from there, so to use the XDG_var..
  ## also use a single dir for all scripts, and use names like aws_security_hub_filter_finding
  # tmuxLastPane = ./../bin/tmux/tmux_last_pane;
in {
  programs.tmux = {
    enable = true;
    # sensibleOnTop = false;
    baseIndex = 1;
    clock24 = true;
    disableConfirmationPrompt = true;
    historyLimit = 50000;
    keyMode = "vi";
    newSession = false;
    prefix = "C-a";
    secureSocket = true;
    tmuxinator.enable = true;

    plugins = with pkgs.tmuxPlugins; [ {
      plugin = yank;
      extraConfig = "
        set -g @yank_selection 'clipboard'
        set -g @yank_selection_mouse 'clipboard'
      ";
      } {
      plugin = tmux-thumbs; # TODO paste with zsh vim-keys
      extraConfig = "
        set -g @thumbs-unique enabled
        set -g @thumbs-reverse enabled
        set -g @thumbs-position off_left
        set -g @thumbs-command 'tmux set-buffer -- {} && tmux paste-buffer'
        set -g @thumbs-upcase-command 'tmux set-buffer -- {}'
        set -g @thumbs-fg-color green
        set -g @thumbs-hint-fg-color red
      ";
      }
      tmux-fzf
      vim-tmux-navigator
    ];

    extraConfig = ''
      ${builtins.readFile ./tmux.conf}

      bind-key g run-shell -b "sh ${tmuxFzfPath}/share/tmux-plugins/tmux-fzf/scripts/pane.sh switch"

      #############################
      ## STATUS BAR
      #############################
      set -g status-interval 5
      set -g status-left-length 30
      set -g status-right-length 150
      set-option -g status "on"

      # Default statusbar color
      set-option -g status-style bg=#1F2335,fg=#1F2335
      # Default window title colors
      set-window-option -g window-status-style bg=colour214,fg=colour237
      # Default window with an activity alert
      set-window-option -g window-status-activity-style bg=colour237,fg=colour248
      # active window title colors
      set-window-option -g window-status-current-style bg=red,fg=colour237
      # active pane border color
      set-option -g pane-active-border-style fg=colour214
      # inactive pane border color
      set-option -g pane-border-style fg=colour255
      # Clock
      set-window-option -g clock-mode-colour colour109
      # Message info
      set-option -g message-style bg=#1F2335,fg=colour223

      set-option -g status-left "\
      #[fg=colour7, bg=#1F2335]#{?client_prefix,#[bg=colour167],} ❐ #S  \
      #[fg=#1F2335, bg=#1F2335]#{?client_prefix,#[fg=colour167],}"

      set-option -g status-right "\
      #[fg=colour223, bg=#1F2335] \
      #[fg=colour246, bg=#1F2335]  %b %d '%y\
      #[fg=colour109]  %H:%M \
      #[fg=colour248, bg=#1F2335]"

      set-window-option -g window-status-current-format "\
      #[fg=#1F2335, bg=colour214] #I|\
      #[fg=colour239, bg=colour214, bold]#W \
      #[fg=colour214, bg=#1F2335]"

      set-window-option -g window-status-format "\
      #[fg=colour223,bg=#1F2335] #I|\
      #[fg=colour223, bg=#1F2335]#W "
    '';
  };
}
