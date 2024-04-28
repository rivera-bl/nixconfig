{ config, ...}:
let
  colors = config.colorScheme.colors;
in {
  programs.starship = {
    # ( '⇣⇡' '⇣' '⇡' '+' 'x' '!' '>' '?' )
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;

    settings = {
      format = "
[┌─$nix_shell($directory)](bold fg:#${colors.base0F})$kubernetes$python$aws
[└─($character)](bold fg:#${colors.base0F})";
      right_format = "$cmd_duration";
      add_newline = false;
      line_break = { disabled = true; };

      #############################
      ### Essentials
      #############################

      cmd_duration = {
        format = "[$duration]($style)";
        show_notifications = false;
      };

      username = {
        format = "[$user]($style)";
        disabled = true;
        show_always = true;
      };

      hostname = {
        disabled = true;
        style = "fg:62";
        ssh_only = true;
        format = "[$ssh_symbol](bold blue)[@]($style)[$hostname]($style)($style)";
        trim_at = ".companyname.com";
      };

      directory = {
        truncate_to_repo = false;
        truncation_length = 2;
        read_only = "";
        format = "[\\($path\\)](69)";
      };

      git_branch = {
        style = "fg:62";
        format = "$symbol[\\[$branch(:$remote_branch)\\]]($style)";
        disabled = true;
      };

      git_status = {
        style = "bold yellow";
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
        disabled = true;
      };

      character = {
       success_symbol = "[\\$](fg:#${colors.base0F})";
       error_symbol = "[x](fg:#${colors.base0F})";
       vicmd_symbol = "[\\$](bold yellow)";
       disabled = false;
      };

      nix_shell = {
        format = "[$symbol]($style)";
        impure_msg = "";
        symbol = " ";
        style = "bold blue dimmed";
      };
      # 🏄⛵
      kubernetes = {
        format = " 🏄 [$context](32) [\{$namespace\}](32)";
        # detect_files = [".k8s"]; # detect_extensions, detect_files, and detect_folders
        disabled = false;
        context_aliases = {
          "default" = "melchior";
          "kind-casper" = "casper";
          "arn:aws:eks:us-east-1:817860761669:cluster/helios-cluster" = "helios";
        };
        # ^arn:aws:eks:\w+(?:-\w+)+:\d{12}:cluster\/[A-Za-z0-9]+(?:-[A-Za-z0-9]+)+$
        # context_aliases = {
        # };
      };

      aws = {
        format = " [$symbol($profile)]($style)";
        symbol = "🌦️  " ;
        style = "fg:62";
        force_display = true;
      };

      python = {
        format = " [$symbol$version]($style)";
        # version_format = "v$\{major\}.$\{minor\}";
        disabled = false;
      };

      #############################
      ### Languages
      #############################

      lua = { disabled = true; };
      nodejs = { disabled = true; };
      terraform = { disabled = true; };
      c = { disabled = true; };

    };
  };
}
