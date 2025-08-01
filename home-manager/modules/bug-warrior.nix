{
  config,
  pkgs,
  lib,
  ...
}:
let
  xdgConfigPath = "$XDG_CONFIG_HOME/bugwarrior/bugwarrior.rc";
  # Needed to serparate configurations so that we can use https_proxy for one of them.
  # TODO: Put tokens into nix-sops somehow? https://github.com/Mic92/sops-nix/issues/62
  commonConfig = {
    general = {
      annotation_links = true;
      annotation_comments = true;
      log.level = "DEBUG";
      taskrc = "$XDG_CONFIG_HOME/task/taskrc";
    };
  };

  githubConfig = lib.recursiveUpdate commonConfig {
    general.targets = "github_issues";
    github_issues = {
      service = "github";
      github.include_user_repos = "False";
      github.username = "jarviliam";
      github.login = "jarviliam";
      github.token = "@oracle:eval:cat $XDG_CONFIG_HOME/bugwarrior/gh";
      github.include_repos = "HENNGE/saascore";
    };
  };

  mkConfig = name: config: {
    # systemd.user.services."bugwarrior-${name}" = {
    #   Service = {
    #     Type = "oneshot";
    #     ExecStart = "${bugwarrior}/bin/bugwarrior-pull";
    #     Environment = [
    #       "BUGWARRIORRC=${pkgs.writeText "bugwarrior.rc" (lib.generators.toINI { } config)}"
    #       "PATH=${
    #         lib.makeBinPath (
    #           with pkgs;
    #           [
    #             taskwarrior
    #             gnugrep
    #             coreutils
    #           ]
    #         )
    #       }"
    #     ];
    #   };
    # };
    # systemd.user.timers."bugwarrior-${name}" = {
    #   Unit = {
    #     Description = "bugwarrior sync with AHT gitlab projects";
    #   };
    #   Timer = {
    #     OnCalendar = "hourly";
    #     Unit = "bugwarrior-${name}.service";
    #   };
    #   Install = {
    #     WantedBy = [ "timers.target" ];
    #   };
    # };
  };
in
{
  xdg.configFile."bugwarrior/bugwarriorrc".text = lib.generators.toINI { } githubConfig;
}
