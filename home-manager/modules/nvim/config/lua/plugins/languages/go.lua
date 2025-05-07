---@type LazySpec[]
return {
  { "maxandron/goplements.nvim" },
  {
    "fredrikaverpil/godoc.nvim",
    dev = false,
    version = "*",
    ft = { "go" },
    build = "go install github.com/lotusirous/gostdsym/stdsym@latest", -- optional
    cmd = { "GoDoc" },
  },
}
