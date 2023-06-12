{
  programs.git = {
    enable = true;
    aliases = {
      pushall = "!git remote | xargs -L1 git push --all";
    };
    difftastic.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      url."https://github.com/".insteadOf = "git://github.com/";
      # this messes up zplug if no key added yet
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
      # can't use base16 colors
      color."status" = {
        added = "green";
        changed = "red";
        untracked = "red";
      };
    };
    ignores = [
      ".terraform"
      "terraform.tfstate*"
      ".direnv"
      "result"
      "Session.vim"
      ".venv*"
      "Makefile"
    ];
  };
}
