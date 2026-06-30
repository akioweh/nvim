-- Minimal init for the test harness (mini.test).
-- Puts this repo's `lua/` on the runtimepath and, under headless Neovim
-- (i.e. `make test`), wires up `mini.test` from the vendored `deps/mini.nvim`.
--
-- Unit tests only need this repo + mini.test. Integration tests spawn their own
-- child Neovim pointed at the real user config (see tests/helpers.lua).

-- Add the current directory (repo root) to 'runtimepath' so `require("util.*")`
-- and `require("plugins.*")` resolve to this repo's `lua/` files.
vim.cmd([[let &rtp.=','.getcwd()]])

-- Only set up mini.test when running headless (the `make test` path).
if #vim.api.nvim_list_uis() == 0 then
  vim.cmd("set rtp+=deps/mini.nvim")
  require("mini.test").setup()
end
