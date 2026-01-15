Config.later(function()
  vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/olimorris/codecompanion.nvim",
    "https://github.com/ravitemer/codecompanion-history.nvim",
  }, { load = true })

  local default_strategy = {
    name = "copilot",
    model = "claude-sonnet-4",
  }

  local code = require("codecompanion")
  code.setup({
    display = {
      action_palette = {
        provider = "fzf_lua",
      },
      chat = {
        intro_message = "",
        window = {
          layout = "vertical", ---@type "float"|"vertical"|"horizontal"|"buffer"
          position = "right", ---@type "left"|"right"|"top"|"bottom"
          width = 0.4,
        },
      },
      diff = {
        layout = "vertical", ---@type "horizontal"|"vertical"
        provider = "mini_diff", ---@type "default"|"mini_diff"
      },
      inline = {
        layout = "vertical", ---@type "vertical"|"horizontal"|"buffer"
      },
    },
    prompt_library = {
      ["Optimize"] = require("plugins.ai.prompts.optimize"),
      ["Pull Request"] = require("plugins.ai.prompts.pr"),
      ["Refactor"] = require("plugins.ai.prompts.refactor"),
      ["Documentation"] = require("plugins.ai.prompts.documentation"),
    },
    extensions = {
      history = {
        enabled = true,
        auto_generate_title = true,
        auto_save = false,
        title_generation_opts = {
          adapter = "copilot",
          model = "gpt-4.1",
          refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
          max_refreshes = 3,
        },
        chat_filter = function(chat_data)
          local seven_days_ago = os.time() - (7 * 24 * 60 * 60)
          return (chat_data.updated_at >= seven_days_ago) and (chat_data.cwd == vim.fn.getcwd())
        end,
        continue_last_chat = false,
        delete_on_clearing_chat = false,
        keymap = "gh",
        picker = "fzf-lua",
        save_chat_keymap = "sc",
      },
    },
    interactions = {
      chat = {
        adapter = default_strategy,
        slash_commands = {
          buffer = { opts = { provider = "fzf_lua" } },
          file = { opts = { provider = "fzf_lua" } },
          help = { opts = { provider = "fzf_lua" } },
          symbols = { opts = { provider = "fzf_lua" } },
        },
      },
      inline = {
        adapter = default_strategy,
      },
      agent = {
        adapter = default_strategy,
      },
    },
  })

  local ids = {} -- CodeCompanion request ID --> MiniNotify notification ID

  local function format_request_status(ev)
    local name = ev.data.adapter.formatted_name or ev.data.adapter.name
    local msg = name .. " " .. ev.data.interaction .. " request..."
    local level, hl_group = "INFO", "DiagnosticInfo"
    if ev.data.status then
      msg = msg .. ev.data.status
      if ev.data.status ~= "success" then
        level, hl_group = "ERROR", "DiagnosticError"
      end
    end
    return msg, level, hl_group
  end

  Config.new_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestStarted",
    callback = function(ev)
      local msg, level, hl_group = format_request_status(ev)
      ids[ev.data.id] = MiniNotify.add(msg, level, hl_group)
    end,
  })

  Config.new_autocmd({ "User" }, {
    pattern = "CodeCompanionRequestFinished",
    callback = function(ev)
      local msg, level, hl_group = format_request_status(ev)
      local mini_id = ids[ev.data.id]
      if mini_id then
        ids[ev.data.id] = nil
        MiniNotify.update(mini_id, { msg = msg, level = level, hl_group = hl_group })
      else
        mini_id = MiniNotify.add(msg, level, hl_group)
      end
      vim.defer_fn(function()
        MiniNotify.remove(mini_id)
      end, 5000)
    end,
  })
end)
