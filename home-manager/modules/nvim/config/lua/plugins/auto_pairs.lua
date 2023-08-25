return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt" },
      ignored_next_char = "%w",
      enable_check_bracket_line = true,
      check_ts = true,
  }
}
