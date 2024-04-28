{ config, inputs, lib, pkgs, ... }:
{
  imports = [
    ./i3/i3.nix
    ./bat
    ./bottom/bottom.nix
    ./direnv/direnv.nix
    ./lsd/lsd.nix
    ./nvim
    ./tmux/tmux.nix # TODO convert to nix
    ./zsh/zsh.nix
    ./programs/alacritty.nix
    ./programs/git.nix
    ./programs/firefox.nix
    ./programs/fonts.nix
    ./programs/fzf.nix
    ./programs/lazygit.nix
    ./programs/starship.nix
    inputs.nix-colors.homeManagerModule
  ];

  home.file = {
    "tmuxinator" = {
      recursive = true;
      source = ./tmuxinator;
      target = ".config/tmuxinator";
     };
    "abbreviations" = {
      source = ./zsh/abbr.zsh;
      target = ".config/zsh/abbreviations";
    };
    "containers" = {
      source = ./containers/auth.json;
      target = ".docker/config.json";
    };
  };

  programs = {
    home-manager = { enable = true; };
    nix-index = { enable = true; }; # 10m to build the index
    z-lua = { enable = true; };
    # just = { enable = true; }; # zsh error _arguments:comparguments:325
    starship.settings.kubernetes.detect_files = [".k8s"];
    git.userName = "rivera-bl";
    git.userEmail = "rivvera.pabblo@gmail.com";
    tmux.terminal = "tmux-256color";
  };

  # darcula,tokyo-night-dark
  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark;

  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    SHELL = "zsh";
    XDG_DESKTOP_DIR = "$HOME";
    XDG_DOWNLOAD_DIR = "/tmp";
    XDG_DATA_HOME = "~/.local/share";
  };

  nixpkgs.config = import ./nixpkgs/config.nix; # --impure
  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs/config.nix;
}
