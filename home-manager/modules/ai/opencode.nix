{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  skillCfg = config.programs.ai.skills;
  enabledSkills = lib.filterAttrs (_: g: g.enable) skillCfg;

  skillSourceRoot = g: if g.input != null then inputs.${g.input} else g.path;

  skillFilePath =
    g: id:
    let
      root = toString (skillSourceRoot g);
      subdir = lib.optionalString (g.subdir != null) "/${g.subdir}";
    in
    "${root}${subdir}/${id}/SKILL.md";

  skillParts = content: lib.splitString "\n---\n" content;

  skillDescription =
    content:
    let
      frontmatter = lib.removePrefix "---\n" (lib.elemAt (skillParts content) 0);
      descriptionLine = lib.findFirst (line: lib.hasPrefix "description: " line) "" (
        lib.splitString "\n" frontmatter
      );
    in
    lib.removePrefix "description: " descriptionLine;

  skillBody = content: lib.removePrefix "\n" (lib.elemAt (skillParts content) 1);

  muxWrap =
    server:
    let
      stateless = server.stateless or false;
      base = builtins.removeAttrs server [ "stateless" ];
    in
    base
    // {
      command = lib.getExe pkgs.mcp-mux;
      args = lib.optional stateless "-stateless" ++ [ base.command ] ++ (base.args or [ ]);
    };

  commandName =
    groupName: g: id:
    lib.replaceStrings [ "/" ] [ "-" ] (
      if g.name != null then "${g.name}-${id}" else "${groupName}-${id}"
    );

  commands = lib.listToAttrs (
    lib.flatten (
      lib.mapAttrsToList (
        groupName: g:
        map (
          id:
          let
            content = builtins.readFile (skillFilePath g id);
          in
          lib.nameValuePair (commandName groupName g id) ''
            ---
            description: ${skillDescription content}
            ---

            ${skillBody content}
          ''
        ) g.ids
      ) enabledSkills
    )
  );

  mcpServers = {
    git = muxWrap {
      command = lib.getExe pkgs.mcp-srv-git-rs;
      args = [
        "--features"
        "inspection,remotes,worktrees,notes"
      ];
      enabled = false;
    };
    nixos = muxWrap {
      command = lib.getExe pkgs.mcp-nixos;
      enabled = false;
    };
  };

  lspServers = {
    bash = {
      command = lib.getExe pkgs.bash-language-server;
      args = [ "start" ];
    };
    go = {
      command = lib.getExe pkgs.gopls;
    };
    lua = {
      command = lib.getExe pkgs.emmylua-ls;
    };
    nix = {
      command = lib.getExe pkgs.nil;
    };
    rust = {
      command = lib.getExe pkgs.rust-analyzer;
      args = [ "--disable-build-scripts" ];
    };
    toml = {
      command = lib.getExe pkgs.tombi;
      args = [ "lsp" ];
    };
    typescript = {
      command = lib.getExe pkgs.typescript;
      args = [
        "--lsp"
        "--stdio"
      ];
    };
  };
  lspExtensions = {
    lua = [ ".lua" ];
    nix = [ ".nix" ];
    rust = [ ".rs" ];
    toml = [ ".toml" ];
    typescript = [
      ".ts"
      ".tsx"
      ".js"
      ".jsx"
    ];
  };

  opencodeLsp = lib.mapAttrs (name: v: {
    command = [ v.command ] ++ (v.args or [ ]);
    extensions = lspExtensions.${name};
  }) (lib.filterAttrs (n: _: lspExtensions ? ${n}) lspServers);

in
{
  options.programs.opencode.extraPlugins = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "Additional opencode plugins appended to the base set.";
  };
  config = {
    programs.opencode.enable = lib.mkDefault true;
    programs.agent-skills.targets.opencode.enable = true;

    home = {
      packages = [
        pkgs.llm-agents.opencode2
        pkgs.mcp-srv-git-rs
        pkgs.mcp-nixos
        pkgs.mcp-mux
      ];

      sessionVariables = {
        # https://opencode.ai/docs/cli/#environment-variables
        OPENCODE_DISABLE_AUTOUPDATE = 1;
        # https://opencode.ai/docs/rules/#claude-code-compatibility
        OPENCODE_DISABLE_CLAUDE_CODE = 1;
        OPENCODE_DISABLE_LSP_DOWNLOAD = 1;
        # https://opencode.ai/docs/cli/#experimental
        OPENCODE_EXPERIMENTAL = 1;
        OPENCODE_EXPERIMENTAL_FILEWATCHER = 1;
        OPENCODE_EXPERIMENTAL_ICON_DISCOVERY = 1;
        OPENCODE_EXPERIMENTAL_LSP_TOOL = 1;
        OPENCODE_EXPERIMENTAL_LSP_TY = 1;
        OPENCODE_EXPERIMENTAL_MARKDOWN = 1;
        OPENCODE_EXPERIMENTAL_OXFMT = 1;
        OPENCODE_EXPERIMENTAL_PLAN_MODE = 1;
      };
    };

    programs.mcp = {
      enable = true;
      servers = mcpServers;
    };

    programs.opencode = {
      package = pkgs.llm-agents.opencode;
      enableMcpIntegration = true;

      settings.lsp = opencodeLsp;

      extraPlugins = [
        "@tianhuil/opencode-hashlines@0.1.0"
        "@capybearista/opencode-output-styles@1.0.1"
        "cc-safety-net@2.3.2" # https://ccsafetynet.com/
      ];

      # opencode-hashlines replaces the built-in edit tool with hash-anchored
      # hashread/hashedit. Disable the native edit tool so the model uses it.
      commands = commands;

      tui = {
        scroll_acceleration = {
          enabled = true;
        };
      };

      settings = {
        autoupdate = lib.mkDefault true;
        compaction = {
          auto = true;
          prune = true;
          reserved = 32000;
        };
        tools.edit = false;

        plugins = config.programs.opencode.extraPlugins;

        watcher.ignore = [
          ".direnv/**"
          ".git/**"
          ".rumdl_cache/**"
          "dist/**"
          "node_modules/**"
          "target/**"
        ];
      };
    };
  };
}
