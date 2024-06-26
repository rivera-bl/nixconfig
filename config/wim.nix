{ config, inputs, lib, pkgs, ... }:
{
  imports = [
    ./bat
    ./bottom
    ./direnv
    ./lsd
    ./nvim
    ./tmux
    ./zsh
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
    "tmuxinator" = {
      recursive = true;
      source = ./tmuxinator;
      target = ".config/tmuxinator";
     };
    "abbreviations" = {
      source = ./zsh/abbr.zsh;
      target = ".config/zsh/abbreviations";
    };
    "lsd-theme" = {
      source = ./lsd/themes/wim.yaml;
      target = ".config/lsd/themes/wim.yaml";
    };
    # "npmrc" = {
    #   source = ./npm/.npmrc;
    #   target = ".npmrc";
    # };
    # "docker-auth" = {
    #   source = ./containers/auth.json;
    #   target = ".docker/config.json";
    # };
    # "docker-certs" = {
    #   recursive = true;
    #   source = ./containers/certs.d;
    #   target = ".docker/certs.d";
    # };
    # TODO encrypt this file
    "sqls" = {
      source = ./sqls/config.yaml;
      target = ".config/sqls/config.yaml";
    };
  };

  programs = {
    home-manager = { enable = true; };
    nix-index = { enable = true; }; # 10m to build the index
    z-lua = { enable = true; };
    # just = { enable = true; }; # zsh error _arguments:comparguments:325
    git.userName = "rivera-bl";
    git.userEmail = "rivera.pablo1090@gmail.com";
    tmux.terminal = "tmux-256color";
  };

  # darcula,tokyo-night-dark,gruvbox-dark-pale
  colorScheme = inputs.nixcolors.colorSchemes.tokyo-night-dark;

  home.sessionVariables = {
    TMUX_TMPDIR = "/tmp";
    EDITOR = "nvim";
    BROWSER = "firefox";
    SHELL = "zsh";
    XDG_DESKTOP_DIR = "$HOME";
    XDG_DOWNLOAD_DIR = "/tmp";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_STATE_HOME = "$HOME/.local/state";
  };
}
