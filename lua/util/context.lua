--- Feature-gating predicates for lazy.nvim `enabled`/`cond` fields, driven by the
--- runtime environment (see util.platform). For environment / availability gating
--- only — NOT opinionated plugin choices (picker, terminal, colorscheme, ...).
---
--- Each builder returns a `fun(): boolean` (lazy accepts `boolean | fun():boolean`
--- for both `enabled` and `cond`); returning a function uniformly defers
--- evaluation and keeps the type consistent across call sites.
---
--- Pure and LazyVim-free.

local platform = require("util.platform")

local M = {}

--- Enabled only when NOT running inside vscode-neovim.
---@return fun(): boolean
function M.not_vscode()
  return function()
    return not platform.is_vscode
  end
end

--- Enabled only when the runtime env is one of the given values.
---@param ... "linux"|"windows"|"msys2"
---@return fun(): boolean
function M.on_env(...)
  local allowed = { ... }
  return function()
    return vim.tbl_contains(allowed, platform.env)
  end
end

--- Enabled only when `bin` is on PATH right now.
---@param bin string
---@return fun(): boolean
function M.if_executable(bin)
  return function()
    return platform.executable(bin)
  end
end

--- Enabled only when one of the marker files is found upward from the cwd
--- (the same root-marker pattern as e.g. a platformio.ini gate).
---@param markers string[]
---@return fun(): boolean
function M.if_root(markers)
  return function()
    return vim.fs.root(vim.uv.cwd() or ".", markers) ~= nil
  end
end

--- Enabled when the tool is usable now (system) or installable via the active
--- Mason strategy. Requires util.tools lazily (at call time).
---@param key string
---@return fun(): boolean
function M.has_tool(key)
  return function()
    local tools = require("util.tools")
    return platform.executable(tools.bin(key)) or tools.use_mason(key)
  end
end

return M
