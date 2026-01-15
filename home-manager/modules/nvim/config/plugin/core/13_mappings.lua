local map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

local nmap = function(lhs, rhs, desc, opts)
  map("n", lhs, rhs, desc, opts)
end

local vmap = function(lhs, rhs, desc, opts)
  map("v", lhs, rhs, desc, opts)
end

local L = function(key)
  return "<leader>" .. key
end
local C = function(cmd)
  return "<Cmd>" .. cmd .. "<CR>"
end

Config.leader_group_clues = {
  -- Leader/movement groups.
  { mode = "n", keys = L("a"), desc = "+ai" },
  { mode = "v", keys = L("a"), desc = "+ai" },
  { mode = "n", keys = L("b"), desc = "+buffers" },
  { mode = "n", keys = L("c"), desc = "+code" },
  { mode = "x", keys = L("c"), desc = "+code" },
  { mode = "n", keys = L("d"), desc = "+debug" },
  { mode = "n", keys = L("f"), desc = "+find" },
  { mode = "x", keys = L("f"), desc = "+find" },
  { mode = "n", keys = L("fd"), desc = "+find dap" },
  { mode = "n", keys = L("g"), desc = "+git" },
  { mode = "n", keys = "gc", desc = "+comment" },
  { mode = "n", keys = L("gd"), desc = "+diff" },
  { mode = "n", keys = L("o"), desc = "+overseer" },
  { mode = "n", keys = L("r"), desc = "+rules" },
  { mode = "n", keys = L("s"), desc = "+search" },
  { mode = "n", keys = L("S"), desc = "+session" },
  { mode = "n", keys = L("T"), desc = "+tabs" },
  { mode = "n", keys = L("t"), desc = "+tests" },
  { mode = "n", keys = "\\", desc = "+toggle" },
  { mode = "n", keys = L("u"), desc = "+ui" },
  { mode = "n", keys = L("x"), desc = "+loclist/quickfix" },
  { mode = "n", keys = L("z"), desc = "+fold" },
}

nmap("vv", "V")
nmap("V", "v$")

-- better indenting
map("v", "<", "<gv", "Indent Left")
map("v", ">", ">gv", "Indent Right")

nmap("<C-d>", "<C-d>zz", "Scroll downwards")
nmap("<C-u>", "<C-u>zz", "Scroll upwards")
nmap("n", "nzzzv", "Next result")
nmap("n", "Nzzzv", "Previous result")

-- Powerful <esc>.
map({ "i", "s", "n" }, "<esc>", function()
  if require("luasnip").expand_or_jumpable() then
    require("luasnip").unlink_current()
  end
  vim.cmd("noh")
  return "<esc>"
end, "Escape, clear hlsearch, and stop snippet session", { expr = true })

-- b is for 'Buffer'. Common usage:
-- - `<Leader>bs` - create scratch (temporary) buffer
-- - `<Leader>ba` - navigate to the alternative buffer
-- - `<Leader>bw` - wipeout (fully delete) current buffer
local new_scratch_buffer = function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

-- lsp
nmap("grn", vim.lsp.buf.rename, "Rename symbol")
nmap("gra", "lua Config.code_action()", "lsp: code actions")
nmap(L("ci"), "lua Config.toggle_hints", "lsp: toggle hint")

nmap("[d", function()
  vim.diagnostic.jump({ count = -1 })
end, "Previous diagnostic")
nmap("]d", function()
  vim.diagnostic.jump({ count = 1 })
end, "Next diagnostic")
nmap("[e", function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, "Previous error")
nmap("]e", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, "Next error")
-- lsp

-- buffer
nmap(L("ba"), C("b#"), "Alternate")
nmap(L("bd"), C("lua MiniBufremove.delete()"), "Delete")
nmap(L("bD"), C("lua MiniBufremove.delete(0, true)"), "Delete!")
nmap(L("bs"), new_scratch_buffer, "Scratch")
nmap(L("bw"), C("lua MiniBufremove.wipeout()>"), "Wipeout")
nmap(L("bW"), C("lua MiniBufremove.wipeout(0, true)"), "Wipeout!")
-- buffer

nmap(L("co"), C("AerialToggle"), "Symbols Outline")
nmap(L("cd"), vim.diagnostic.open_float, "Line Diagnostics")

nmap(L("og"), C("Neogen"), "Generate definition")
nmap(L("of"), C("Neogen func"), "Generate definition (F)")
nmap(L("oc"), C("Neogen class"), "Generate definition (C)")

-- fzf
nmap(L(":"), C("FzfLua command_history"), "Command History")
nmap(L("/"), C("FzfLua live_grep"), "Grep (Root Dir)")
nmap(L("<space>"), C("FzfLua files"), "Find Files (Root Dir)")
nmap(L("f;"), C("FzfLua resume"), "Resume Picker")

nmap(L("ff"), C("FzfLua files"), "Find File")
nmap(L("fb"), C("FzfLua buffers sort_mru=true sort_lastused=true"), "Buffer Picker")
nmap(L("fC"), C("FzfLua git_bcommits"), "Buffer Commits")
nmap(L("fg"), C("FzfLua git_files"), "Find Files (Git)")
nmap(L("sb"), C("FzfLua blines"), "Buffer Lines")
nmap(L("sB"), C("FzfLua lines"), "Grep Open Buffers")

nmap(L("sw"), C("FzfLua grep_cword"), "grep <word> (project)")
nmap(L("sW"), C("FzfLua grep_cWORD"), "grep <WORD> (project)")
nmap(L('s"'), C("FzfLua registers"), "Registers")
nmap(L("s/"), C("FzfLua search_history"), "Search History")
nmap(L("sa"), C("FzfLua autocmds"), "Auto Commands")
nmap(L("sc"), C("FzfLua command_history"), "Command History")
nmap(L("sC"), C("FzfLua commands"), "Commands")
nmap(L("sd"), C("FzfLua diagnostics_document"), "Document Diagnostics")
nmap(L("sD"), C("FzfLua diagnostics_workspace"), "Workspace Diagnostics")
nmap(L("sh"), C("FzfLua help_tags"), "Help Pages")
nmap(L("sH"), C("FzfLua highlights"), "Search Highlight Groups")
nmap(L("sj"), C("FzfLua jumps"), "Jumps")
nmap(L("sm"), C("FzfLua marks"), "Marks")

nmap(L("f?"), C("FzfLua builtin"), "builtin")
nmap(L("sM"), C("FzfLua man_pages"), "Man Pages")

-- git
nmap(L("gd"), C("FzfLua git_hunks"), "Git Diff (hunks)")

nmap(L("sk"), C("FzfLua keymaps"), "Keymaps")
nmap(L("sq"), C("FzfLua quickfix"), "Quickfix List")
-- fzf

-- overseer
nmap(L("ot"), C("OverseerToggle"), "Toggle Overseer")
nmap(L("oo"), C("OverseerRun"), "Run task")
nmap(L("oq"), C("OverseerQuickAction"), "Action recent task")
nmap(L("oi"), C("OverseerInfo"), "Overseer Info")
nmap(L("ob"), C("OverseerBuild"), "Task builder")
nmap(L("oa"), C("OverseerTaskAction"), "Task action")
nmap(L("oc"), C("OverseerClearCache"), "Clear cache")
-- overseer

-- quicker
nmap(L("q"), C("lua require('quicker').toggle()"), "Toggle quickfix")

-- ai
nmap(L("aa"), C("CodeCompanionActions"), "Actions")
nmap(L("aq"), C("CodeCompanionChat"), "New Chat")
nmap(L("ac"), C("CodeCompanionChat Toggle"), "Toggle chat")
vmap(L("ad"), C("CodeCompanion /doc"), "Documentation")
vmap(L("al"), C("CodeCompanion /lsp"), "LSP Diag")
vmap(L("af"), C("CodeCompanion /fix"), "Fix Code")
nmap(L("ap"), C("CodeCompanion /pr"), "Pull Request")
vmap(L("ao"), C("CodeCompanion /optimize"), "Optimize")
vmap(L("ar"), C("CodeCompanion /refactor"), "Refactor")
vmap(L("at"), C("CodeCompanion /tests"), "Generate Tests")
nmap(L("aw"), C("CodeCompanion /workflow"), "Code Workflow")

-- testing
nmap(L("ta"), function()
  require("neotest").run.attach()
end, "Attach")
nmap(L("tf"), function()
  require("neotest").run.run(vim.fn.expand("%"))
end, "Run File")
nmap(L("tt"), function()
  require("neotest").run.run()
end, "Run Nearest")
nmap(L("tx"), function()
  require("neotest").run.stop()
end, "Stop")
nmap(L("tl"), function()
  require("neotest").run.run_last()
end, "Run Last")
nmap(L("ts"), function()
  require("neotest").summary.toggle()
end, "Toggle Summary")
nmap(L("tw"), function()
  require("neotest").watch.toggle(vim.fn.expand("%"))
end, "Toggle Watch")
nmap(L("to"), function()
  require("neotest").output.open({ enter = true, auto_close = true })
end, "Show Output")
nmap(L("tO"), function()
  require("neotest").output_panel.toggle()
end, "Toggle Output Panel")

nmap(L("dB"), function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Breakpoint Condition")
nmap(L("db"), function()
  require("dap").toggle_breakpoint()
end, "Toggle Breakpoint")
nmap(L("dc"), function()
  require("dap").continue()
end, "Continue")
nmap("<F5>", "<cmd>DapContinue<cr>", "Continue")
nmap(L("dC"), function()
  require("dap").run_to_cursor()
end, "Run to Cursor")
nmap(L("dg"), function()
  require("dap").goto_()
end, "Go to Line (No Execute)")
nmap(L("di"), function()
  require("dap").step_into()
end, "Step Into")
nmap(L("dj"), function()
  require("dap").down()
end, "Down")
nmap(L("dk"), function()
  require("dap").up()
end, "Up")
nmap(L("dl"), function()
  require("dap").step_over()
end, "Step Over")
nmap(L("do"), function()
  require("dap").step_out()
end, "Step Out")
nmap(L("dO"), function()
  require("dap").step_over()
end, "Step Over")
nmap(L("dp"), function()
  require("dap").pause()
end, "Pause")
nmap(L("dr"), function()
  require("dap").run_last()
end, "Run Last")
nmap(L("ds"), function()
  require("dap").session()
end, "Session")
nmap(L("dt"), function()
  require("dap").terminate()
end, "Terminate")
nmap(L("td"), function()
  require("neotest").run.run({ strategy = "dap" })
end, "Debug Nearest")
