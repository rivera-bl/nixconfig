{ config, inputs, lib, pkgs, ... }:
{
  imports = [
    ./pkgs
    ./tmux
    ./zsh
    ./bat
    ./bottom
    ./direnv
    ./lsd
    ./bash
    ./git
    ./fonts
    ./fzf
    ./lazygit
    ./starship
    inputs.nixcolors.homeManagerModule
  ];

  home.file = {
    "bin" = {
      recursive = true;
      source = ../bin;
      target = ".local/bin";
     };
    "tmuxprojects" = {
      recursive = true;
      source = ./tmuxinator;
      target = ".config/tmuxinator";
     };
    "abbreviations" = {
      source = ./zsh/abbr.zsh;
      target = ".config/zsh/abbreviations";
    };
    "nixconf" = {
      source = ./nix/nix.conf;
      target = ".config/nix/nix.conf";
    };
    "lsd-theme" = {
      source = ./lsd/themes/wim.yaml;
      target = ".config/lsd/themes/wim.yaml";
    };
  };

  programs = {
    home-manager = { enable = true; };
    git.userName = "rivera-bl";
    git.userEmail = "rivera.pablo1090@gmail.com";
    tmux.terminal = "tmux-256color";
  };

  # darcula,tokyo-night-dark,gruvbox-dark-pale
  colorScheme = inputs.nixcolors.colorSchemes.tokyo-night-dark;

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    XDG_DESKTOP_DIR = "$HOME";
    XDG_DOWNLOAD_DIR = "/tmp";
    XDG_CONFIG_HOME = "$HOME/.config";
  };
}
