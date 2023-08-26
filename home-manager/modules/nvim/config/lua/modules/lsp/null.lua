local M = {}

local fmt_group = vim.api.nvim_create_augroup("LspFormatting", {})
function M.setup()
  local nls = require("null-ls")
  local fmt = nls.builtins.formatting
  local dgn = nls.builtins.diagnostics
  nls.setup({
    debounce = 150,
    save_after_format = false,
    sources = {
      fmt.trim_whitespace.with({
        filetypes = { "text", "sh", "zsh", "toml", "make", "conf", "tmux" },
      }),
      fmt.prettierd,
      fmt.rustfmt,
      fmt.stylua.with({
        extra_args = {
          "--config-path",
          vim.fn.expand("~/.config/stylua.toml"),
        },
      }),
      fmt.ruff,
      fmt.nixfmt,
      dgn.ruff,
      fmt.terraform_fmt,
      fmt.gofmt,
      fmt.goimports,
      fmt.clang_format,
      fmt.black,
      fmt.shfmt,
      dgn.yamllint,
      nls.builtins.hover.dictionary,
      dgn.actionlint.with({
        condition = function()
          local name = vim.api.nvim_buf_get_name(0)
          return string.find(name, ".github")
        end,
      }),
      dgn.luacheck.with({
        extra_args = {
          "--config-path",
          vim.fn.expand("~/.config/nvim/.luacheckrc"),
        },
      }),
      dgn.codespell,
    },
    on_attach = function(client, bufnr)
      if client.server_capabilities.documentFormatting then
        vim.api.nvim_clear_autocmds({ group = fmt_group, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = fmt_group,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({
              timeout_ms = 2000,
              bufnr = bufnr,
            })
          end,
        })
      end
      vim.keymap.set(
        "n",
        "<leader>lf",
        [[<cmd>lua vim.lsp.buf.format({async=true,name="null-ls"})<CR>]],
        { silent = true, buffer = bufnr, desc = "format document [null-ls]" }
      )
    end,
    root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".nvim.settings.json", ".git"),
  })
end

function M.has_formatter(ft)
  local sources = require("null-ls.sources")
  local available = sources.get_available(ft, "NULL_LS_FORMATTING")
  return #available > 0
end

return M
