return {
  "NeogitOrg/neogit",
  cmd = { "Neogit" },
  dev = false,
  opts = {
    disable_signs = false,
    disable_context_highlighting = false,
    disable_commit_confirmation = false,
    disable_builtin_notifications = true,
    signs = {
      -- { CLOSED, OPENED }
      section = { ">", "v" },
      item = { ">", "v" },
      hunk = { "", "" },
    },
    integrations = {
      diffview = true,
      telescope = false,
      fzf_lua = true,
    },
  },
}
