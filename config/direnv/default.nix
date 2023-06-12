{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = false;
    stdlib = "";
    config = {
      whitelist = {
        exact = [
          "~/code/gitlab/pos/cl/cem-prem-k8"
        ];
      };
    };
  };
}
