-- Clean-install assertion (run by `make test-install` after `Lazy! install`).
-- By the time this runs, the real config has loaded and lazy has resolved every
-- plugin. Assert each one exists on disk; exit nonzero (cquit) on any miss so the
-- clean-install target fails loudly in CI.

local uv = vim.uv or vim.loop
local config = require("lazy.core.config")

local missing = {}
for name, plugin in pairs(config.plugins) do
  if not (plugin.dir and uv.fs_stat(plugin.dir)) then
    missing[#missing + 1] = name
  end
end

local total = vim.tbl_count(config.plugins)
if #missing > 0 then
  io.stderr:write(
    ("clean-install FAILED: %d/%d plugins missing on disk:\n  %s\n"):format(
      #missing,
      total,
      table.concat(missing, "\n  ")
    )
  )
  vim.cmd("cquit 1")
end

io.stdout:write(("clean-install OK: %d plugins installed\n"):format(total))
