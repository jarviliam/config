return {
  {
    "echasnovski/mini.comment",
    event = "BufReadPre",
    opts = {},
    config = function()
      require("mini.comment").setup({})
    end,
  },
  {
    "echasnovski/mini.jump",
    branch = "stable",
    event = "BufReadPre",
    opts = {
      mappings = {
        forward = "f",
        backward = "F",
        forward_till = "t",
        backward_till = "T",
        repeat_jump = "",
      },
    },
    config = function(_, opts)
      require("mini.jump").setup(opts)
    end,
  },
  {
      "echasnovski/mini.surround",
      event = "BufReadPre",
      opts = {
        search_method = "cover_or_next",
        highlight_duration = 2000,
        mappings = {
          add = "ys",
          delete = "ds",
          replace = "cs",
          highlight = "",
          find = "",
          find_left = "",
          update_n_lines = "",
        },
        custom_surroundings = {
          ["("] = { output = { left = "( ", right = " )" } },
          ["["] = { output = { left = "[ ", right = " ]" } },
          ["{"] = { output = { left = "{ ", right = " }" } },
          ["<"] = { output = { left = "<", right = ">" } },
          ["|"] = { output = { left = "|", right = "|" } },
          ["%"] = { output = { left = "<% ", right = " %>" } },
        },
      },
      config = function(_, opts)
        require("mini.surround").setup(opts)
      end,
    },
  {
      "echasnovski/mini.bufremove",
      config = function()
        require("mini.bufremove").setup({})
      end,
    },
 {
    "echasnovski/mini.move",
    config = function()
      require("mini.move").setup({
        mappings = {
          right = "", -- noop
          left = "", -- noop
          line_left = "", -- noop
          line_right = "", -- noop
        },
      })
    end,
  },
 {
    "echasnovski/mini.bracketed",
    config = function()
      require("mini.bracketed").setup({})
    end,
  },
}
