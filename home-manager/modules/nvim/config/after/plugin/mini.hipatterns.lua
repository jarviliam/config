local mp = require("mini.hipatterns")

--- Create HL for words
---@param words table
---@param hl string
local hi_todo = function(words, hl)
  local pattern = vim
    .iter(words)
    :map(function(word)
      return { "%f[%w]()" .. word .. "()%f[%W]", "() " .. word .. "[: ]()" }
    end)
    :flatten()
    :totable()
  return {
    pattern = pattern,
    group = function(buf, _, m)
      local parser = vim.treesitter.get_parser(buf, nil, { error = false })
      if not parser then
        return hl
      end
      local node = parser:named_node_for_range({
        m.line - 1,
        m.from_col - 1,
        m.line - 1,
        m.to_col - 1,
      })
      if not node or (node:type() == "comment_content" or "comment") then
        return hl
      end
      return nil
    end,
  }
end

local highlighters = {
  fix = hi_todo({ "FIX", "FIXME" }, "MiniHipatternsFixme"),
  note = hi_todo({ "NOTE" }, "MiniHipatternsNote"),
  todo = hi_todo({ "TODO" }, "MiniHipatternsTodo"),
  hack = hi_todo({ "HACK" }, "MiniHipatternsHack"),
  perf = hi_todo({ "PERF" }, "MiniHipatternsPerf"),
}

mp.setup({
  highlighters = highlighters,
})
