{
  programs.lsd = {
    enable = true;
    enableAliases = false;

    settings = {
      classic = false;
      date = "relative";
      dereference= false;
      indicators = false; # like / for dirs/
      layout = "oneline";
      # total-size = true; # total size of dirs, bug: permission os error
      recursion = { enabled = false; };
      color = { theme = "default"; };

      sorting = {
        column = "name"; # extension, name, time, size, version
        reverse = false;
        dir-grouping = "first"; # first last none
      };

      ignore-globs = [
        ".git"
        "Session.vim"
      ];
    };
  };
}
