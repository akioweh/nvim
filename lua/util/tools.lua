--- Decides, per tool, whether it should be sourced from the system PATH or
--- installed/managed by Mason.
---
--- Strategy (`vim.g.tools_strategy`):
---   "smart" (default) - system-first: use a system install when one is detected
---                       on PATH, otherwise let Mason fill the gap.
---   "mason"           - Mason manages everything.
---
--- A machine-local override file (JSON, no UI) can force specific tools either
--- way regardless of detection — e.g. force "mason" when the system version is
--- too old. It lives under stdpath("state") so it is NOT committed (an override
--- is a per-machine correction, not config-as-code).
---
--- Pure-ish and LazyVim-free; consumed from plugin specs (mason / lspconfig /
--- mason-nvim-dap). Requiring it only registers the :ToolForce command.

local platform = require("util.platform")

local M = {}

--- Tool key -> probe info. A "key" may be an lspconfig server name OR a Mason
--- package name; both resolve here to the binary we look for on PATH. Only
--- entries whose binary differs from the key (or that need a custom probe) are
--- listed; everything else defaults to `bin == key`.
---@type table<string, { bin?: string, probe?: fun(): boolean }>
M.registry = {
  -- lspconfig server name -> on-PATH binary
  lua_ls = { bin = "lua-language-server" },
  hls = { bin = "haskell-language-server-wrapper" },
  basedpyright = { bin = "basedpyright-langserver" },
  pyright = { bin = "pyright-langserver" },
  ltex_plus = { bin = "ltex-ls-plus" },
  -- Mason package name -> on-PATH binary (when different)
  ["haskell-language-server"] = { bin = "haskell-language-server-wrapper" },
  ["tree-sitter-cli"] = { bin = "tree-sitter" },
  -- DAP: no standalone executable, needs a custom probe
  debugpy = {
    probe = function()
      return M.has_debugpy()
    end,
  },
}

--- mason-nvim-dap adapter name -> tool key (for resolution).
---@type table<string, string>
M.dap_alias = { python = "debugpy" }

--- Path of the machine-local override file. Overridable in tests.
M.override_path = vim.fn.stdpath("state") .. "/nvim-tool-overrides.json"

local cache_state ---@type table?

--- Clear the in-session override cache (used by tests).
function M._reset()
  cache_state = nil
end

---@return { version: integer, force: table<string,string>, cache: table<string,boolean> }
local function read_state()
  if cache_state then
    return cache_state
  end
  local default = { version = 1, force = {}, cache = {} }
  if vim.fn.filereadable(M.override_path) == 0 then
    cache_state = default
    return cache_state
  end
  local ok, decoded = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(M.override_path), "\n"))
  end)
  if not ok or type(decoded) ~= "table" then
    vim.notify("util.tools: could not parse " .. M.override_path .. " (ignoring)", vim.log.levels.WARN)
    cache_state = default
    return cache_state
  end
  decoded.version = decoded.version or 1
  decoded.force = decoded.force or {}
  decoded.cache = decoded.cache or {}
  cache_state = decoded
  return cache_state
end

---@param state table
local function write_state(state)
  cache_state = state
  -- Best-effort: a read-only state dir (e.g. a sandbox) must not break startup.
  pcall(function()
    vim.fn.mkdir(vim.fn.fnamemodify(M.override_path, ":h"), "p")
    vim.fn.writefile({ vim.json.encode(state) }, M.override_path)
  end)
end

---@return "smart"|"mason"
function M.strategy()
  return vim.g.tools_strategy == "mason" and "mason" or "smart"
end

--- The PATH-ordering Mason should use: system bins win under "smart" (Mason only
--- fills gaps), Mason is authoritative under "mason".
---@return "append"|"prepend"
function M.mason_path_mode()
  return M.strategy() == "mason" and "prepend" or "append"
end

--- The binary to probe on PATH for a given tool key.
---@param key string
---@return string
function M.bin(key)
  local e = M.registry[key]
  return (e and e.bin) or key
end

--- A forced choice for this tool, if any: "mason" | "system" | nil.
---@param key string
---@return string?
function M.override(key)
  return read_state().force[key]
end

--- Set (or clear, when value is nil) a forced choice; persisted to the file.
---@param key string
---@param value "mason"|"system"|nil
function M.force(key, value)
  local state = read_state()
  state.force[key] = value
  write_state(state)
end

--- Is a usable system install of this tool detected right now?
---@param key string
---@return boolean
function M.has_system(key)
  local e = M.registry[key]
  if e and e.probe then
    return e.probe()
  end
  return platform.executable(M.bin(key))
end

--- Should this tool be managed by Mason?
---@param key string
---@return boolean
function M.use_mason(key)
  -- Escape hatch: never auto-install (treat everything as system-provided).
  -- Useful on offline/locked-down machines and in tests that just load the config.
  if vim.env.NVIM_NO_AUTO_INSTALL == "1" then
    return false
  end
  if M.strategy() == "mason" then
    return true
  end
  local forced = M.override(key)
  if forced == "mason" then
    return true
  end
  if forced == "system" then
    return false
  end
  return not M.has_system(key)
end

--- Probe whether a system Python can import debugpy. Result is cached in the
--- override file so this one-time (bounded) subprocess runs at most once/machine.
---@return boolean
function M.has_debugpy()
  local state = read_state()
  if state.cache.debugpy ~= nil then
    return state.cache.debugpy
  end
  local py
  for _, c in ipairs({ "python3", "python", "py" }) do
    if platform.executable(c) then
      py = c
      break
    end
  end
  local result = false
  if py then
    local ok, r = pcall(function()
      return vim.system({ py, "-c", "import debugpy" }, { text = true }):wait(2000)
    end)
    result = ok and r ~= nil and r.code == 0
  end
  state.cache.debugpy = result
  write_state(state)
  return result
end

-- :ToolForce <tool> [mason|system]   (omit the value to clear an override;
-- omit everything to print the current forces)
vim.api.nvim_create_user_command("ToolForce", function(o)
  local key, value = o.fargs[1], o.fargs[2]
  if not key then
    local st = read_state()
    vim.print({ force = st.force, cache = st.cache })
    return
  end
  if value and value ~= "mason" and value ~= "system" then
    vim.notify("ToolForce: value must be 'mason' or 'system'", vim.log.levels.ERROR)
    return
  end
  M.force(key, value)
  vim.notify(("ToolForce: %s -> %s (restart to apply)"):format(key, value or "auto"), vim.log.levels.INFO)
end, {
  nargs = "*",
  complete = function(arglead, line)
    -- second arg: complete the value; first arg: complete known tool keys
    if line:match("^%s*ToolForce%s+%S+%s+%S*$") then
      return vim.tbl_filter(function(v)
        return v:find(arglead, 1, true) == 1
      end, { "mason", "system" })
    end
    return vim.tbl_filter(function(v)
      return v:find(arglead, 1, true) == 1
    end, vim.tbl_keys(M.registry))
  end,
})

return M
