{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.programs.ai.skills;
  enabled = lib.filterAttrs (_: g: g.enable) cfg;

  srcName = key: g: if g.name != null then g.name else key;

  sourceOf =
    g:
    (if g.input != null then { inherit (g) input; } else { inherit (g) path; })
    // lib.optionalAttrs (g.subdir != null) { inherit (g) subdir; }
    // lib.optionalAttrs (g.idPrefix != null) { inherit (g) idPrefix; };

  groupType = lib.types.submodule {
    options = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether this skill group is active.";
      };

      name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Name for the skill group.";
      };

      input = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Flake input name backing the group's agent-skills source.";
      };

      path = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path backing the group's source (mutually exclusive with input).";
      };

      subdir = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Subdirectory under the source root holding the skills.";
      };

      idPrefix = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Namespace prepended to this group's discovered skill IDs.";
      };

      all = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable every skill discovered in this group's source.";
      };

      ids = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Specific skill IDs to enable from this group.";
      };
    };
  };
in
{
  imports = [ inputs.agent-skills.homeManagerModules.default ];

  options.programs.ai.skills = lib.mkOption {
    type = lib.types.attrsOf groupType;
    default = { };
    description = "Named, individually toggleable skill groups.";
  };

  config = lib.mkMerge [
    {
      programs.agent-skills.enable = true;

      programs.ai.skills = {
        mattpocock-engineering = {
          name = "mattpocock-engineering";
          input = "mattpocock-skills";
          subdir = "skills/engineering";
          ids = [
            "codebase-design"
          ];
        };

        mattpocock-productivity = {
          name = "mattpocock-productivity";
          input = "mattpocock-skills";
          subdir = "skills/productivity";
          ids = [
            "grilling"
          ];
        };
      };
    }

    (lib.mkIf (enabled != { }) {
      assertions = lib.mapAttrsToList (name: g: {
        assertion = (g.input != null) != (g.path != null);
        message = "programs.ai.skills.${name}: set exactly one of `input` or `path`.";
      }) enabled;

      programs.agent-skills = {
        sources = lib.mapAttrs' (key: g: lib.nameValuePair (srcName key g) (sourceOf g)) enabled;
        skills = {
          enable = lib.concatMap (g: g.ids) (lib.attrValues enabled);
          enableAll = lib.mapAttrsToList srcName (lib.filterAttrs (_: g: g.all) enabled);
        };
      };
    })
  ];
}
