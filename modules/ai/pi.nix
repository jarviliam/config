{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.pi-coding-agent;

  skillCfg = config.programs.ai.skills;
  enabledSkills = lib.filterAttrs (_: g: g.enable) skillCfg;

  # tintinweb/pi-subagents and teelicht/pi-superagents both own
  # extensions/subagent/; install exactly one. Superpowers integrates with the
  # teelicht fork, so track its enable state for pi.
  piSuperpowers = lib.elem "pi" config.programs.ai.superpowers.agents;

  skillSourceRoot = g: if g.input != null then inputs.${g.input} else g.path;

  skillFilePath =
    g: id:
    let
      root = toString (skillSourceRoot g);
      subdir = lib.optionalString (g.subdir != null) "/${g.subdir}";
    in
    "${root}${subdir}/${id}/SKILL.md";

  piSkills = lib.unique (
    lib.concatMap (g: map (id: skillFilePath g id) g.ids) (lib.attrValues enabledSkills)
  );

  superpowersSkills = lib.optionals piSuperpowers [ "${inputs.superpowers}/skills" ];

  jsonFormat = pkgs.formats.json { };
  piLspServers = import ./lsp.nix { inherit lib pkgs; };
  piSuperagentsConfig = jsonFormat.generate "pi-superagents.json" {
    superagents.modelTiers = {
      cheap.model = "claude-sonnet-5-5";
      balanced = {
        model = "gpt-6-luna";
        thinking = "high";
      };
      max = {
        model = "gpt-6-astra";
        thinking = "high";
      };
    };
  };

  mcpServers = {
    git = {
      type = "stdio";
      command = lib.getExe pkgs.mcp-srv-git-rs;
      args = [
        "--features"
        "inspection,remotes,worktrees,notes"
      ];
      enabled = false;
    };

    nixos = {
      type = "stdio";
      command = lib.getExe pkgs.mcp-nixos;
      enabled = false;
    };

    todoist = {
      type = "streamable-http";
      url = "https://ai.todoist.net/mcp";
      description = "Todoist tasks and projects via Todoist's hosted MCP server.";
    };
  };

  piPackages = [
    {
      source = "npm:@dietrichgebert/ponytail";
      skills = [ "./skills/ponytail" ];
    }
    "npm:pi-away"
    # Broke on rex
    # "npm:pi-background"
    "npm:pi-checkpoints"
    "npm:pi-codemode-toggle"
    "npm:pi-compact-tools"
    "npm:pi-context-view"
    "npm:pi-hashline-edit-pro-lean"
    "npm:pi-inspector"
    "npm:pi-next-prompt"
    "npm:@injaneity/pi-computer-use"
    "npm:@optomatica/pi-auto-session-name"
    "npm:@pi-unipi/compactor@alpha"
    "npm:@pi-unipi/memory@alpha"
    "npm:@pi-unipi/notify@alpha"
    "npm:@ssk_dev/pi-docs-slim"
    "npm:@ssk_dev/rpiv-ask-user-question-lean"
    "npm:@ssk_dev/rpiv-todo-lean"
    "npm:@tifan/pi-copy-response"
    "npm:@vanillagreen/pi-skills-manager"
    "npm:pi-powerline-footer"
    "npm:@narumitw/pi-lsp"
    "npm:@vanillagreen/pi-session-manager"
    # "npm:pi-rex-adapter"
    "npm:@ssk_dev/pi-subagents-lean"
  ]
  ++ lib.optionals piSuperpowers [
    {
      source = inputs.superpowers;
    }
  ];
in
{
  options.programs.ai.superpowers.agents = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ "pi" ];
    description = "Agents that should load the Superpowers package.";
  };

  config = {
    programs.uv = {
      enable = true;

      tool = {
        packages = [
          "mempalace"
        ];

        prune = true;
      };
    };
    programs.agent-skills.targets.pi.enable = true;
    programs.pi-coding-agent.enable = true;
    programs.pi-coding-agent.settings = {
      compaction = {
        enabled = true;
        reserveTokens = 16384;
        keepRecentTokens = 20000;
      };
      defaultModel = "gpt-6-luna";
      defaultProvider = "github-copilot";

      defaultTools = [
        "+codemode"
      ];

      quietStartup = true;

      powerline = {
        preset = "nerd";
        separator = "slash";
        welcome = true;

        layout = {
          left = [
            "model"
            "thinking"
            "path"
          ];

          right = [
            "context_pct"
            "subagents"
          ];
        };

        model.showThinkingLevel = false;
        path.mode = "basename";

        git = {
          showBranch = false;
          showStaged = false;
          showUnstaged = false;
          showUntracked = false;
        };
      };

      packages = piPackages;

      skills = piSkills ++ superpowersSkills;
    };

    home.activation.piSuperagentsConfig = lib.mkIf piSuperpowers (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        config_path="${config.home.homeDirectory}/${cfg.configDir}/extensions/subagent/config.json"
        rm -f "$config_path"
        install -Dm644 ${piSuperagentsConfig} "$config_path"
      ''
    );

    home.packages = [
      pkgs.mcp-srv-git-rs
      pkgs.mcp-nixos
    ];

    home.file."${cfg.configDir}/mcp.json".source = jsonFormat.generate "pi-mcp.json" {
      mcpServers = mcpServers;
    };

    home.file."${cfg.configDir}/pi-lsp.json".source = jsonFormat.generate "pi-lsp.json" {
      servers = piLspServers;
    };
  };
}
