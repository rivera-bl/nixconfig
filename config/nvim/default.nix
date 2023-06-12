{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    # TODO read a dir
    # WARN make sure that every plugin config file sources has its plugin installed
    # otherwise if it has a return fallback then it will break other plugins
    # since hm merges all into one file
    extraConfig = ''
      lua << EOF
        ${builtins.readFile ./lua/user/cmp.lua}
        ${builtins.readFile ./lua/user/cmd.lua}
        ${builtins.readFile ./lua/user/colorizer.lua}
        ${builtins.readFile ./lua/user/colorscheme.lua}
        ${builtins.readFile ./lua/user/indentline.lua}
        ${builtins.readFile ./lua/user/keymap.lua}
        ${builtins.readFile ./lua/user/lsp.lua}
        ${builtins.readFile ./lua/user/lualine.lua}
        ${builtins.readFile ./lua/user/neodev.lua}
        ${builtins.readFile ./lua/user/nvimtree.lua}
        ${builtins.readFile ./lua/user/setting.lua}
        ${builtins.readFile ./lua/user/treesitter.lua}
        ${builtins.readFile ./lua/user/utils.lua}
      EOF
    '';
    plugins = (import ./plugins.nix pkgs).myPlugins;
  };
}
