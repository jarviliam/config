{ pkgs, ... }:
let
  gitReview = pkgs.writeShellScriptBin "git-review" ''
    #!/usr/bin/env bash
    (
      TARGET_DIR=''${REVIEW_WORKTREE/#\~/$HOME}
      if [ -n "$TARGET_DIR" ]; then
        cd "$TARGET_DIR" || exit
      fi

      YELLOW="\e[33m"
      RESET="\e[0m"
      
      # 1. Selection Function using fzf
      sel() {
        # Fetch PRs with metadata, format for fzf, and pick one
        local choice
        choice=$(gh pr list --search "review-requested:@me" \
          --json number,title,headRefName,baseRefName \
          --template '{{range .}}#{{.number}} | {{.title}} | {{.headRefName}} | {{.baseRefName}}{{"\n"}}{{end}}' | \
          fzf --ansi --header "Select PR to Review" --prompt "PR > ")

        if [ -n "$choice" ]; then
          # Extract branch (3rd column) and base (4th column) from the selection
          local target_branch=$(echo "$choice" | cut -d'|' -f3 | xargs)
          local target_base=$(echo "$choice" | cut -d'|' -f4 | xargs)
          # Restart this script with the selected branch and base
          exec git-review "$target_branch" "origin/$target_base"
        fi
      }

      export branch="''${1#origin/}"
      export base="''${2:-origin/master}"

      # If no branch is provided as an argument, immediately trigger selection
      if [ -z "$1" ]; then
        sel
      fi

      git switch -d "origin/$branch"
      echo -e "Reviewing $YELLOW$branch$RESET -> $base"

        d() { git diff --merge-base $base --stat $@ ; }
        l() { git log "$base..HEAD" --oneline $@ ; }
        r() { 
          nvim -c "GcLog ''${base}..HEAD" \
           -c "clast" \
           "$@" ;}

        l  # display log

        r
        declare -fx d l r sel
        exec zsh -i
    )
  '';
in
{

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  home = {
    packages = [ gitReview ];
    sessionVariables = {
      # _ZO_FZF_OPTS = "${fzfOpts} --bind=ctrl-z:ignore --exit-0 --info=default --layout=reverse-list --no-sort --select-1";
    };
  };
}
