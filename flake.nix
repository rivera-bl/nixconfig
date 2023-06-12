{
  description = "Portable home configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcolors = {
      url = "github:misterio77/nix-colors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fws = {
      url = "github:rivera-bl/flakes?dir=fws";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gla = {
      url = "github:rivera-bl/flakes?dir=gla";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kfc = {
      url = "github:rivera-bl/flakes?dir=kfc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fim = {
      url = "github:rivera-bl/flakes?dir=fim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ez2 = {
      url = "github:rivera-bl/flakes?dir=ez2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    iamlive = {
      url = "github:rivera-bl/flakes?dir=iamlive";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # TODO how to dinamically build home based on username
  outputs = inputs@{ nixpkgs, home-manager, nixcolors, fws, gla, kfc, fim, ez2, iamlive, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.wim = home-manager.lib.homeManagerConfiguration {
       inherit pkgs;
       modules = [
        { _module.args = inputs; }
        ./config/wim.nix
         {
           home = {
            homeDirectory = "/home/wim";
            username = "wim";
            stateVersion = "23.05";
           };
         }
       ];
       extraSpecialArgs = { inherit inputs; };
      };

      homeConfigurations.casper = home-manager.lib.homeManagerConfiguration {
       inherit pkgs;
       modules = [
        { _module.args = inputs; }
        ./config/casper.nix
         {
           home = {
            homeDirectory = "/home/casper";
            username = "casper";
            stateVersion = "23.05";
           };
         }
       ];
       extraSpecialArgs = { inherit inputs; };
      };
      # devShells.${system}.default = with pkgs;
      #   mkShell {
      #     buildInputs = [ ];
      #   };
    };
}
