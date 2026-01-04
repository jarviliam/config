---@type vim.lsp.Config
-- return {
--   cmd = { "nil" },
--   filetypes = { "nix" },
--   root_markers = {
--     "flake.nix",
--     "shell.nix",
--     "default.nix",
--   },
--   settings = {
--     ["nil"] = {
--       formatting = { command = { "nixpkgs-fmt" } },
--       nix = {
--         flake = {
--           autoArchive = false,
--           autoEvalImputs = true,
--         },
--       },
--     },
--   },
-- }
return {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", ".git" },
}
