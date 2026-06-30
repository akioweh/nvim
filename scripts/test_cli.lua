-- Headless test runner driven by `make test` (mirrors the grug-far fork).
--
-- Env knobs (set via `make test dir=... file=... line=...`):
--   dir   - restrict collection to tests/<dir>/**/test_*.lua
--   file  - run a single file (relative to tests/ or tests/<dir>/)
--   line  - run only the test at that line in `file`
--   group_depth - reporter grouping depth (with line=)
-- `update_screenshots=true` is read directly by the screenshot helper.

vim.cmd([[let &rtp.=','.getcwd()]])
vim.cmd("set rtp+=deps/mini.nvim")
require("mini.test").setup()
local MiniTest = require("mini.test")

local file = vim.env.file
local line = vim.env.line
local dir = vim.env.dir
local group_depth = vim.env.group_depth

local opts = {}
if dir then
  opts.collect = {
    find_files = function()
      return vim.fn.globpath("tests/" .. dir, "**/test_*.lua", true, true)
    end,
  }
end

if file then
  file = "tests/" .. (dir and dir .. "/" or "") .. file
  if line then
    opts.execute = {
      reporter = MiniTest.gen_reporter.stdout({ group_depth = group_depth }),
    }
    MiniTest.run_at_location({ file = file, line = tonumber(line) }, opts)
  else
    MiniTest.run_file(file, opts)
  end
else
  MiniTest.run(opts)
end
