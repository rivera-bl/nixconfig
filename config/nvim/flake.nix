{
  description = "Neovim Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      ls = with pkgs; {
        rnix = [ cargo rustc rnix-lsp ];
        tf = [ terraform terraform-ls ];
        sumneko = [ sumneko-lua-language-server ];
        yaml = [ yaml-language-server ];
      };
      deps = ls.rnix ++ ls.tf ++ ls.sumneko ++ ls.yaml;
    in {
      packages.default = with pkgs;
        neovim.override {
          vimAlias = true;
          viAlias = true;
          configure = {
            packages.myPlugins = with pkgs.vimPlugins; {
              start = (import ./plugins.nix pkgs).myPlugins;
              opt = [];
            };

            customRC = ''
              lua << EOF
                ${builtins.readFile ./lua/settings.lua}
                ${builtins.readFile ./lua/mappings.lua}
                ${builtins.readFile ./lua/telescope_lua.lua}
                ${builtins.readFile ./lua/lualine_lua/init.lua}
                ${builtins.readFile ./lua/user/indentline.lua}
                ${builtins.readFile ./lua/user/cmp.lua}
                ${builtins.readFile ./lua/user/colorscheme.lua}
                ${builtins.readFile ./lua/user/colorizer.lua}
                ${builtins.readFile ./lua/user/lsp/init.lua}
              EOF
            '';
          };
        };

      packages.image = pkgs.dockerTools.buildLayeredImage {
        name = "nvim-flake";
        tag = "latest";
        contents = deps ++ [self.packages.${system}.default];

        config = {
          Cmd = ["/bin/nvim"];
          WorkingDir = "/";
        };
      };

      devShells.default = with pkgs;
        mkShell {
          buildInputs = deps;
        };
    });
}
