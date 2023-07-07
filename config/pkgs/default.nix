{ pkgs, inputs, ... }:
{
  # TODO split into multiple files, for different roles
  home.packages = with pkgs; [
    zip unzip bc inetutils
    wsl-open xdg-utils
    xclip xsel
    neofetch

    zsh
    git
    pre-commit
    jq
    ydiff
    ripgrep
    ansifilter

    awscli2
    ssm-session-manager-plugin
    amazon-ecr-credential-helper

    vault
    jwt-cli
    consul

    minikube
    kubectl kubecolor krew kustomize trivy stern linkerd datree argocd helm-docs
    terraform terraform-ls terraform-docs hcl2json tfk8s terraformer
    checkov
    crane

    # lua
    go
    python3 poetry
    # cargo rustc rnix-lsp
    # gnumake cmake gcc
    # sqlite postgresql

    # sumneko-lua-language-server
    # yaml-language-server
    nodePackages.pyright

    inputs.fws.packages.${system}.default
    inputs.gla.packages.${system}.default
    inputs.fim.packages.${system}.default
    inputs.ez2.packages.${system}.default
    inputs.iamlive.packages.${system}.default
    inputs.kfc.defaultPackage.${system}
  ];
}
