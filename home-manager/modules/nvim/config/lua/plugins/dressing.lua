return {
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        enabled = false,
      },
      select = {
        trim_prompt = true,
        get_config = function(opts)
          local winopts = { height = 0.6, width = 0.5 }

          -- Smaller menu for snippet choices.
          if opts.kind == "luasnip" then
            opts.prompt = "Snippet choice: "
            winopts = { height = 0.35, width = 0.3 }
          end

          -- Add a colon to the prompt if it doesn't have one.
          if opts.prompt and not opts.prompt:match(":%s*$") then
            opts.prompt = opts.prompt .. ": "
          end

          return {
            backend = "fzf_lua",
            fzf_lua = { winopts = winopts },
          }
        end,
      },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
    end,
  },
}
