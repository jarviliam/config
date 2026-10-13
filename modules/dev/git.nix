{
  lib,
  roles,
  pkgs,
  ...
}:
let
  hasRole = role: lib.elem role roles;
  exclude_bots = "--perl-regexp --author='^((?!dependabot|renovate).*)$'";
  email = "jarviliam@gmail.com";
in
{
  config = lib.mkIf (hasRole "dev") {

    home.packages = with pkgs; [
      git-ignore
      git-who
      git-trim
      lazyworktree
      worktrunk
    ];
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Liam Jarvis";
          email = "jarviliam@gmail.com";
        };
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        init.defaultBranch = "main";

        alias = {
          # Basic shortcuts
          a = "commit --amend";
          aa = "add --all";
          amend = "commit --amend";
          co = "checkout";
          dc = "diff --cached";
          unadd = "restore --staged";
          unstage = "reset HEAD --";
          untrack = "rm --cached";

          # Diff operations
          dlc = "diff --cached HEAD^";

          # Log formatting
          l = "log --pretty=oneline -n 20 --graph --abbrev-commit ${exclude_bots}";

          overview = "log --all --since='2 weeks' --oneline --no-merges ${exclude_bots}";
          recap = "log --all --oneline --no-merges --author=${email}";
          today = "log --since=00:00:00 --all --oneline --no-merges --author=${email}";

          # Utility commands
          rescue = "!git fsck --full --no-reflogs --unreachable --lost-found | grep commit | cut -d\\  -f3 | xargs -n 1 git log -n 1 --pretty=oneline > .git/lost-found.txt";
          pending = "!git log $(git describe --tags --abbrev=0)..HEAD --oneline";
          fixup = "!git commit --fixup $(git rev-parse HEAD)";
        };

        diff = {
          navigate = true; # use n and N to move between diff sections
          renames = "copies"; # Detect copies as well as renames.

          algorithm = "histogram"; # Better diffing algorithm.
          colorMoved = "zebra"; # Highlight moved lines as oldMoved -> newMoved.
          mnemonicPrefix = true; # Use better letters than a/ and b/ in diffs.
        };

        push = {
          gpgSign = "if-asked";
        };

        rebase = {
          autosquash = true;
        };
      };

      signing = {
        signByDefault = true;
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA6dihydKY7KAgf4xHcDYrVl7xF3rXUeDVmxfryqTXzN";
        format = "ssh";
      };
      ignores = [
        ".DS_Store"
        "._*"
        ".Spotlight-V100"
        ".Trashes"
        "Thumbs.db"
        "Desktop.ini"

        # AI
        ".claude"
        ".claude/settings.local.json"
        ".opencode/"

        # Environment
        ".direnv/"

        # IDE
        "*.iml"
        "*.ipr"
        "*.iws"
        "*.swo"
        "*.swp"
        "*.vscode"

        # Language servers
        "buildServer.json"
        ".ccls-cache"
        ".clangd-build-session"
        ".compile"
        "compile_commands.json"
        ".nvim/xcodebuild"
        "/.pkl-lsp/"
      ];
    };

  };
}
