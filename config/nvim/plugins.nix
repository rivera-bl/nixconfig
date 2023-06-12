{
  pkgs,
  lib,
  ...
}: let
  customPlugins = {
    vim-bufsurf = pkgs.vimUtils.buildVimPlugin rec {
      pname = "vim-bufsurf";
      version = "v0.3";
      src = pkgs.fetchFromGitHub {
        owner = "ton";
        repo = "vim-bufsurf";
        rev = "e6dbc7ad66c7e436e5eb20d304464e378bd7f28c";
        sha256 = "sha256-o/Uf4bnh3IctKnT50JitTe5/+BUrCyrlOOzkmwAzxLk=";
      };
      meta.homepage = "https://github.com/ton/vim-bufsurf";
    };
    vim-kubernetes = pkgs.vimUtils.buildVimPlugin rec {
      pname = "vim-kubernetes";
      version = "v0.2.0";
      src = pkgs.fetchFromGitHub {
        owner = "andrewstuart";
        repo = "vim-kubernetes";
        rev = "d5fe1c319b994149b25c9bee1327dc8b3bebe4b7";
        sha256 = "sha256-BtuGFF78+OtsJr/PdWOJK9vR+QkqCd4MTwq3DZAfmDo=";
      };
    };
  };
in {
  myPlugins = with pkgs.vimPlugins; [
    customPlugins.vim-bufsurf
    customPlugins.vim-kubernetes
    # git:
    vim-fugitive
    vim-rhubarb         # needed for :GBrowse github
    fugitive-gitlab-vim # needed for :GBrowse gitlab
    gv-vim
    # completion:
    neodev-nvim
    copilot-vim
    nvim-cmp
    cmp-buffer
    cmp-path
    cmp-cmdline
    cmp-nvim-lsp
    cmp_luasnip
    # cmp-nvim-ultisnips
    # snippets:
    vim-terraform-completion # has snippets
    vim-snippets
    # ultisnips
    # lsp:
    nvim-lspconfig
    # fuzzy search
    popup-nvim
    plenary-nvim
    telescope-nvim
    telescope-fzf-native-nvim
    # looks:
    nvim-web-devicons
    lualine-nvim
    colorbuddy-nvim
    # functions:
    tabular
    vim-wordmotion
    vim-commentary
    vim-eunuch
    vim-obsession
    auto-pairs
    customPlugins.vim-bufsurf
    customPlugins.vim-bufsurf
    # external:
    zeavim-vim
    lazygit-nvim
    vim-tmux-navigator
    # misc:
    which-key-nvim
    indent-blankline-nvim
    # highlight:
    vim-markdown
    vim-terraform
    vim-helm
    nvim-colorizer-lua
    direnv-vim
    fzf-vim
    nvim-tree-lua
    # vim-rooter
    vim-surround

    (nvim-treesitter.withPlugins (
      plugins:
        with plugins; [
          tree-sitter-nix
          tree-sitter-bash
          tree-sitter-json
          tree-sitter-yaml
          tree-sitter-go
          tree-sitter-regex
          tree-sitter-dockerfile
          tree-sitter-python
        ]
    ))
  ];
}
