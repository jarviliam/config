{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Liam Jarvis";
        email = "jarviliam@gmail.com";
      };
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      init.defaultBranch = "main";
    };

    signing = {
      signByDefault = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA6dihydKY7KAgf4xHcDYrVl7xF3rXUeDVmxfryqTXzN";
      format = "ssh";
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
