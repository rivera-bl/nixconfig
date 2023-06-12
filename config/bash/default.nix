{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyFile = "${config.xdg.dataHome}/bash/bash_history";
    historyFileSize = 1000000;
  };
}
