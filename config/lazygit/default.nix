{ config, ...}:
let
  colors = config.colorScheme.colors;
in {
  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        # stuff relating to the UI
        scrollHeight = 2; # how many lines you scroll by
        scrollPastBottom = true; # enable scrolling past the bottom
        sidePanelWidth = 0.3333; # number from 0 to 1
        expandFocusedSidePanel = false;
        mainPanelSplitMode = "horizontal"; # one of "horizontal" | "flexible" | "vertical"
        language = "en";
        timeFormat = "02 Jan 06 15 =04 MST"; # https =//pkg.go.dev/time#Time.Format
        theme = {
          lightTheme = false;
          activeBorderColor = [ "#${colors.base0B}" "bold" ];
          inactiveBorderColor = [ "#${colors.base0A}" ];
          optionsTextColor = [ "blue" ];
          selectedLineBgColor = [ "default" ];
          selectedRangeBgColor = [ "default" ];
          cherryPickedCommitBgColor = [ "cyan" ];
          cherryPickedCommitFgColor = [ "blue" ];
          unstagedChangesColor = [ "red" ];
        };
        commitLength = { show = true; };
        mouseEvents = true;
        skipUnstageLineWarning = false;
        skipStashWarning = false;
        showFileTree = true; # for rendering changes files in a tree format
        showListFooter = true; # for seeing the "5 of 20" message in list panels
        showRandomTip = false;
        showBottomLine = true; # for hiding the bottom information line (unless it has important information to tell you)
        showCommandLog = true;
        showIcons = true;
        commandLogSize = 8;
        splitDiff = "always"; # one of "auto" | "always"
      };

      git = {
        paging = {
          colorArg = "always";
          useConfig = false;
        };
        commit = { signOff = false; };
        merging = {
          # only applicable to unix users
          manualCommit = false;
          # extra args passed to `git merge`, e.g. --no-ff
          args = "";
        };
        log = {
          # one of date-order, author-date-order, topo-order.
          # topo-order makes it easier to read the git log graph, but commits may not
          # appear chronologically. See https =//git-scm.com/docs/git-log#_commit_ordering
          order = "topo-order";
          # one of always, never, when-maximised
          # this determines whether the git graph is rendered in the commits panel
          showGraph = "always";
          # displays the whole git graph by default in the commits panel (equivalent to passing the `--all` argument to `git log`)
          showWholeGraph = false;
        };
        autoFetch = true;
        autoRefresh = true;
        branchLogCmd = "git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --";
        allBranchesLogCmd = "git log --graph --all --color=always --abbrev-commit --decorate --date=relative  --pretty=medium";
        overrideGpg = false; # prevents lazygit from spawning a separate process when using GPG
        disableForcePushing = false;
        parseEmoji = false;
        diffContextSize = 3; # how many lines of context are shown around a change in diffs

      os = {
        editCommand = ""; # see "Configuring File Editing" section
        editCommandTemplate = "";
        openCommand = "";
      };
      refresher = {
        refreshInterval = 10; # File/submodule refresh interval in seconds. Auto-refresh can be disabled via option "git.autoRefresh".
        fetchInterval = 60; # Re-fetch interval in seconds. Auto-fetch can be disabled via option "git.autoFetch".
      };
      update = { 
        method = "prompt"; # can be = prompt | background | never
        days = 14; # how often an update is checked for
      };
      reporting = "undetermined"; # one of = "on" | "off" | "undetermined"
      confirmOnQuit = false;
      # determines whether hitting "esc" will quit the application when there is nothing to cancel/close
      quitOnTopLevelReturn = true;
      disableStartupPopups = false;
      notARepository = "skip"; # one of = "prompt" | "create" | "skip" | "quit"
      promptToReturnFromSubprocess = true; # display confirmation when subprocess terminates
      };
      keybinding = {
        universal = {
          quit = "q";
          quit-alt1 = "<c-q>"; # alternative/alias of quit
          return = "<esc>"; # return to previous menu, will quit if there"s nowhere to return
          quitWithoutChangingDirectory = "Q";
          togglePanel = "<tab>"; # goto the next panel
          prevItem = "<up>"; # go one line up
          nextItem = "<down>"; # go one line down
          prevItem-alt = "k"; # go one line up
          nextItem-alt = "j"; # go one line down
          prevPage = "{"; # go to next page in list
          nextPage = "}"; # go to previous page in list
          gotoTop = "g"; # go to top of list
          gotoBottom = "G"; # go to bottom of list
          scrollLeft = "H"; # scroll left within list view
          scrollRight = "L"; # scroll right within list view
          prevBlock = "h"; # goto the previous block / panel
          nextBlock = "l"; # goto the next block / panel
          prevBlock-alt = "h"; # goto the previous block / panel
          nextBlock-alt = "l"; # goto the next block / panel
          nextMatch = "n";
          prevMatch = "N";
          optionMenu = "x"; # show help menu
          optionMenu-alt1 = "?"; # show help menu
          select = "<space>";
          goInto = "<enter>";
          openRecentRepos = "<c-r>";
          confirm = "<enter>";
          confirm-alt1 = "y";
          remove = "d";
          new = "n";
          edit = "e";
          openFile = "o";
          scrollUpMain = "<pgup>"; # main panel scroll up
          scrollDownMain = "<pgdown>"; # main panel scroll down
          scrollUpMain-alt1 = "<pgup>"; # main panel scroll up
          scrollDownMain-alt1 = "<pgdown>"; # main panel scroll down
          scrollUpMain-alt2 = "<c-u>"; # main panel scroll up
          scrollDownMain-alt2 = "<c-d>"; # main panel scroll down
          executeCustomCommand = ":";
          createRebaseOptionsMenu = "m";
          pushFiles = "P";
          pullFiles = "p";
          refresh = "R";
          createPatchOptionsMenu = "<c-p>";
          nextTab = "]";
          prevTab = "[";
          nextScreenMode = "F";
          prevScreenMode = "_";
          undo = "z";
          redo = "<c-z>";
          filteringMenu = "<c-s>";
          diffingMenu = "W";
          diffingMenu-alt = "<c-e>"; # deprecated
          copyToClipboard = "<c-o>";
          submitEditorText = "<enter>";
          appendNewline = "<a-enter>";
          extrasMenu = "@";
          toggleWhitespaceInDiffView = "<c-w>";
          increaseContextInDiffView = "}";
          decreaseContextInDiffView = "{";
        };
        status = {
          checkForUpdate = "u";
          recentRepos = "<enter>";
        };
        files = {
          commitChanges = "c";
          commitChangesWithoutHook = "w"; # commit changes without pre-commit hook
          amendLastCommit = "A";
          commitChangesWithEditor = "C";
          ignoreFile = "i";
          refreshFiles = "r";
          stashAllChanges = "s";
          viewStashOptions = "S";
          toggleStagedAll = "a"; # stage/unstage all
          viewResetOptions = "D";
          fetch = "f";
          toggleTreeView = "`";
        };
        branches = {
          createPullRequest = "o";
          viewPullRequestOptions = "O";
          checkoutBranchByName = "c";
          forceCheckoutBranch = "F";
          rebaseBranch = "r";
          renameBranch = "R";
          mergeIntoCurrentBranch = "M";
          viewGitFlowOptions = "i";
          fastForward = "f"; # fast-forward this branch from its upstream
          pushTag = "P";
          setUpstream = "u"; # set as upstream of checked-out branch
          fetchRemote = "f";
        };
        commits = {
          squashDown = "s";
          renameCommit = "r";
          renameCommitWithEditor = "R";
          viewResetOptions = " ";
          markCommitAsFixup = "f";
          createFixupCommit = "F"; # create fixup commit for this commit;
          squashAboveCommits = "S";
          moveDownCommit = "<c-j>"; # move commit down one;
          moveUpCommit = "<c-k>"; # move commit up one;
          amendToCommit = "A";
          pickCommit = "p"; # pick commit (when mid-rebase);
          revertCommit = "t";
          cherryPickCopy = "c";
          cherryPickCopyRange = "C";
          pasteCommits = "v";
          tagCommit = "T";
          checkoutCommit = "<space>";
          resetCherryPick = "<c-R>";
          copyCommitMessageToClipboard = "<c-y>";
          openLogMenu = "<c-l>";
          viewBisectOptions = "b";
        };
        stash = {
          popStash = "g";
        };
        commitFiles = {
          checkoutCommitFile = "c";
        };
        main = {
          toggleDragSelect = "v";
          toggleDragSelect-alt = "V";
          toggleSelectHunk = "a";
          pickBothHunks = "b";
        };
        submodules = {
          init = "i";
          update = "u";
          bulkMenu = "b";
        };
      };

      customCommands = [
      {
        key = "R";
        command = "git reset --soft HEAD^";
        context = "commits";
      }
      {
        key = "<c-m>";
        command = "git pull origin {{.SelectedLocalBranch.Name}}";
        context = "localBranches";
      }];
    };
  };
}
