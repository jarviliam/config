{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Liam Jarvis";
    userEmail = "jarviliam@gmail.com";

    signing = {
      signByDefault = true;
      key = "E33BEE679A565815";
    };
    aliases = {
      gone = ''
        !f() { git fetch --all --prune;
              git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D; }; f'';
      today = ''!git log --author = Liam - -oneline - -since="midnight"'';
    };
    delta = {
      enable = true;
    };
    extraConfig = {
      advice = {
        statusHints = true;
      };
      init.defaultBranch = "master";
      credential.helper = "store";
      core.editor = "nvim";
      push.gpgSign = "if-asked";
      rebase.autosquash = true;
    };
    ignores = [
      ".DS_Store"
      "._*"
      ".Spotlight-V100"
      ".Trashes"
      "Thumbs.db"
      "Desktop.ini"
    ];
  };
}
