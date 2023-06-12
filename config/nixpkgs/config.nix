{ pkgs, ... }:
{
  # TODO: get NUR as flake into home-manager
  # fetchTarball is --impure
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball {
          url = "https://github.com/nix-community/NUR/archive/257d816afd5ae241e2d52b64736dbf77f4131d88.tar.gz";
          sha256 = "0ldnqbirgjayn893d7x79jbi734c8njnfn52isj5hn9whk1f8igd";
        }) {
      inherit pkgs;
    };
  };
}
