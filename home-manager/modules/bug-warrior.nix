{
  config,
  pkgs,
  lib,
  ...
}:
let
  commonConfig = {
    general = {
      annotation_links = true;
      annotation_comments = true;
      "log.level" = "DEBUG";
      taskrc = "$XDG_CONFIG_HOME/task/taskrc";
    };
  };

  githubConfig = lib.recursiveUpdate commonConfig {
    general.targets = "github_issues";
    github_issues = {
      service = "github";
      "github.include_user_repos" = "False";
      "github.username" = "jarviliam";
      "github.login" = "jarviliam";
      "github.token" = "@oracle:eval:cat $XDG_CONFIG_HOME/bugwarrior/gh";
      "github.query" =
        "assignee:jarviliam is:open repo:HENNGE/saascore -author:app/hennge-sc-bot is:issue";
    };
  };
in
{
  xdg.configFile."bugwarrior/bugwarriorrc".text = lib.generators.toINI { } githubConfig;
}
