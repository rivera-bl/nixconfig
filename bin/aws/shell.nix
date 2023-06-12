with import <nixpkgs> {};

mkShell {
  name = "boto3";
  buildInputs = with python3Packages; [ venvShellHook ];
  venvDir = ".venv310";
  # tried to nix-shell -p 'python3.withPackages(ps: with ps; [ boto3 ])'
  # but our nixos channel installed 1.24.75
  # # (can't pin specific pkg versions in nix, only system-wide, unless using overlays)
  # so the easiest way is to use pip
  postShellHook = ''
    pip install boto3==1.26.99
    set -o vi
  '';
}
