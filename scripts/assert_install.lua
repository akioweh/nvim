-- Clean-install assertion (run by `make test-install` after `Lazy! install`).
-- By the time this runs, the real config has loaded and lazy has resolved every
-- plugin. Assert each one exists on disk; exit nonzero (cquit) on any miss so the
-- clean-install target fails loudly in CI.
--
-- Exception: plugins matching `dev.patterns` (this config's private `akioweh/*`
-- forks). On a machine with `dev.path` they resolve to a local dir; elsewhere
-- (e.g. CI) lazy's `fallback` tries to clone them and a private repo simply
-- cannot be fetched without the owner's credentials. Those are reported and
-- skipped — the point of this test is that the PUBLIC plugin set installs cleanly.

local uv = vim.uv or vim.loop
local config = require("lazy.core.config")
local patterns = (config.options.dev or {}).patterns or {}

local function is_dev(plugin)
  local hay = (plugin.url or "") .. " " .. (plugin.name or "")
  for _, pat in ipairs(patterns) do
    if hay:find(pat, 1, true) then
      return true
    end
  end
  return false
end

local missing, skipped = {}, {}
for name, plugin in pairs(config.plugins) do
  if not (plugin.dir and uv.fs_stat(plugin.dir)) then
    if is_dev(plugin) then
      skipped[#skipped + 1] = name
    else
      missing[#missing + 1] = name
    end
  end
end

local total = vim.tbl_count(config.plugins)
if #skipped > 0 then
  io.stdout:write(
    ("clean-install: skipped %d unfetchable dev-pattern plugin(s): %s\n"):format(#skipped, table.concat(skipped, ", "))
  )
end
if #missing > 0 then
  io.stderr:write(
    ("clean-install FAILED: %d/%d public plugins missing on disk:\n  %s\n"):format(
      #missing,
      total,
      table.concat(missing, "\n  ")
    )
  )
  vim.cmd("cquit 1")
end

io.stdout:write(
  ("clean-install OK: %d plugins installed (%d dev-pattern skipped)\n"):format(total - #skipped, #skipped)
)
