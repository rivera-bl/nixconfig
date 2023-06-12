{ pkgs, ... }: {
  # better to manage system-wide? keys may differ between machines
  xsession.windowManager.i3 = {
    config.terminal = "alacritty";
    enable = true;
    package = pkgs.i3-gaps;
    config.bars = [];
    extraConfig = builtins.readFile ./config;
  };
}
