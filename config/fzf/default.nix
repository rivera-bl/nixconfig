{ config, ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    # add bind to:
    # select multiple files -> space
    # select and run -> ctrl-l
    # select and edit -> enter
    defaultOptions = [ 
      "--height 50%"
      "--border none"
      "--layout reverse"
      "--info hidden"
      "--bind ctrl-j:down,ctrl-k:up,ctrl-l:accept"
    ];
    
    changeDirWidgetCommand = ""; # ALT-C
    changeDirWidgetOptions = [];

    fileWidgetCommand = "find -L"; # CTRL-T
    fileWidgetOptions = [];

    historyWidgetOptions = [
     "--history-size=10000"
    ]; # CTRL-R

    # requires fzf-tmux plugin
    # shows CTRL-R in floating window
    # tmux = {
    #   enableShellIntegration = true;
    #   shellIntegrationOptions = [
    #   "-p -w 62% -h 38% -m"
    #   ];
    # };
  };

}
