with import <nixpkgs> {};

mkShell {
  name = "boto3";
  buildInputs = with python3Packages; [ venvShellHook ];
  venvDir = ".venv310";
  postShellHook = ''
    pip install boto3==1.26.99
    trap "rm -rf .venv310" EXIT # rm after leaving
  '';
}
