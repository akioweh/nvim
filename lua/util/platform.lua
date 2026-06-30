--- Single source of truth for the runtime environment.
---
--- Pure and LazyVim-free: requiring this module has no side effects and no
--- dependency on plugins, so it is safe to `require("util.platform")` even from
--- `config/lazy.lua` (before LazyVim exists on the runtimepath).
---
--- Detection is written as a pure function of injected inputs (`M._detect`) so
--- tests can feed synthetic environments (linux / windows / msys2 / vscode)
--- without a real OS. The cached public fields are just `_detect(real_inputs())`.
---
--- `env` is the granular runtime string and the value to branch on:
---   "linux"   - Linux (WSL is treated as linux).
---   "windows" - native Windows, NOT launched inside MSYS2.
---   "msys2"   - Neovim is running *inside* an MSYS2 environment (unix-like:
---               /tmp exists, bash shell, make/gcc + unix tools on PATH).
--- "windows" and "msys2" can both be reachable on one machine; which is live
--- depends on how nvim was launched. Orthogonal to `env`, `has_msys2`/`msys2_root`
--- report whether an MSYS2 install is *invokable* even from native Windows (so we
--- can shell out to it for builds while keeping /tmp-style assumptions on `is_msys2`).
---
--- Mac is intentionally out of scope (treated as linux-like via has("win32")==0).

---@class util.platform.Shell
---@field path string
---@field kind "pwsh"|"powershell"|"bash"|"zsh"|"fish"|"cmd"|"sh"|"unknown"
---@field is_msys_bash boolean

---@class util.platform.Inputs
---@field has fun(feature: string): integer        # vim.fn.has
---@field env table<string, string?>               # vim.env (or a synthetic table)
---@field shell string                             # vim.o.shell
---@field exepath fun(name: string): string        # vim.fn.exepath
---@field fs_stat fun(path: string): table?         # vim.uv.fs_stat
---@field vscode any                                # vim.g.vscode

---@class util.platform.Detected
---@field env "linux"|"windows"|"msys2"
---@field is_linux boolean
---@field is_windows boolean                        # native plain windows only
---@field is_msys2 boolean                          # running inside msys2
---@field is_win_os boolean                         # OS is Windows (windows or msys2)
---@field is_unix boolean                           # unix-like runtime (linux or msys2)
---@field is_vscode boolean
---@field shell util.platform.Shell
---@field sep "\\"|"/"
---@field exe_suffix ".exe"|""
---@field has_msys2 boolean
---@field msys2_root string?                        # forward-slashed, no trailing slash

local M = {}

--- Classify a shell from its path. Pure; mutates nothing.
---@param shellpath string?
---@return util.platform.Shell
function M._detect_shell(shellpath)
  shellpath = shellpath or ""
  local function match_end(suf)
    return shellpath:match(suf .. "$") ~= nil or shellpath:match(suf .. "%.exe$") ~= nil
  end
  -- Order matters: specific before general, because "pwsh"/"bash"/"zsh"/"fish"
  -- all end in "sh" and would otherwise be swallowed by the bare "sh" check.
  local kind = "unknown"
  for _, k in ipairs({ "pwsh", "powershell", "bash", "zsh", "fish", "cmd", "sh" }) do
    if match_end(k) then
      kind = k
      break
    end
  end
  -- An msys2 bash lives under a tree whose path contains "msys" (distinguishes it
  -- from Git-for-Windows bash, which also sits at .../usr/bin/bash.exe).
  local is_msys_bash = kind == "bash" and shellpath:lower():match("msys") ~= nil
  return { path = shellpath, kind = kind, is_msys_bash = is_msys_bash }
end

--- Locate an invokable MSYS2 root (ordered, first-hit-wins, each candidate
--- validated by the presence of usr/bin/bash.exe). Windows-only; nil otherwise.
---@param inp util.platform.Inputs
---@param is_win boolean
---@param shell util.platform.Shell
---@return string?
function M._detect_msys2_root(inp, is_win, shell)
  if not is_win then
    return nil
  end
  local function valid(root)
    if not root or root == "" then
      return nil
    end
    root = (root:gsub("\\", "/")):gsub("/+$", "")
    -- Require both bash.exe and pacman.exe: a Git-for-Windows tree also has
    -- usr/bin/bash.exe (so could be reached via `exepath("bash")`) but ships no
    -- pacman, so this keeps us from mistaking it for an MSYS2 root.
    if inp.fs_stat(root .. "/usr/bin/bash.exe") and inp.fs_stat(root .. "/usr/bin/pacman.exe") then
      return root
    end
    return nil
  end

  -- 1. explicit override
  local r = valid(inp.env.NVIM_MSYS2_ROOT)
  if r then
    return r
  end
  -- 2. running inside an msys shell: *_PREFIX points at <root>/<subsystem>
  for _, pfxvar in ipairs({ "MSYSTEM_PREFIX", "MINGW_PREFIX" }) do
    local pfx = inp.env[pfxvar]
    if pfx and pfx ~= "" then
      r = valid(vim.fs.dirname((pfx:gsub("\\", "/"))))
      if r then
        return r
      end
    end
  end
  -- 3. walk up from an msys bash shell path: <root>/usr/bin/bash.exe
  if shell.is_msys_bash and shell.path ~= "" then
    r = valid((shell.path:gsub("\\", "/")):match("^(.*)/usr/bin/bash"))
    if r then
      return r
    end
  end
  -- 4. bash on PATH
  local bash = inp.exepath("bash")
  if bash and bash ~= "" then
    r = valid((bash:gsub("\\", "/")):match("^(.*)/usr/bin/bash"))
    if r then
      return r
    end
  end
  -- 5. well-known locations
  local candidates = { "C:/msys64", "C:/msys32" }
  local userprofile = inp.env.USERPROFILE
  if userprofile and userprofile ~= "" then
    candidates[#candidates + 1] = (userprofile:gsub("\\", "/")) .. "/scoop/apps/msys2/current"
  end
  for _, c in ipairs(candidates) do
    r = valid(c)
    if r then
      return r
    end
  end
  return nil
end

--- Pure detection. Feed `real_inputs()` in production or a synthetic table in tests.
---@param inp util.platform.Inputs
---@return util.platform.Detected
function M._detect(inp)
  local is_win = inp.has("win32") == 1
  local shell = M._detect_shell(inp.shell)
  local msystem = inp.env.MSYSTEM
  local in_msys = is_win and ((msystem ~= nil and msystem ~= "") or shell.is_msys_bash)

  local res = {}
  res.shell = shell
  if not is_win then
    res.env = "linux"
  elseif in_msys then
    res.env = "msys2"
  else
    res.env = "windows"
  end
  res.is_linux = res.env == "linux"
  res.is_windows = res.env == "windows"
  res.is_msys2 = res.env == "msys2"
  res.is_win_os = is_win
  res.is_unix = res.is_linux or res.is_msys2
  res.is_vscode = inp.vscode ~= nil
  res.sep = is_win and "\\" or "/"
  res.exe_suffix = is_win and ".exe" or ""
  res.msys2_root = M._detect_msys2_root(inp, is_win, shell)
  res.has_msys2 = res.msys2_root ~= nil
  return res
end

--- The live OS inputs used in production.
---@return util.platform.Inputs
local function real_inputs()
  return {
    has = vim.fn.has,
    env = vim.env,
    shell = vim.o.shell,
    exepath = vim.fn.exepath,
    fs_stat = vim.uv.fs_stat,
    vscode = vim.g.vscode,
  }
end

--- Re-run detection and refresh the cached fields. Call this after mutating
--- `vim.o.shell` (e.g. options.lua's cmd -> pwsh switch) so the shell-derived
--- fields stay authoritative.
function M.refresh()
  for k, v in pairs(M._detect(real_inputs())) do
    M[k] = v
  end
end

-- Computed once at require; refreshed by options.lua after shell finalization.
M.refresh()

--- Is `bin` on PATH right now? (Live — not part of cached detection.)
---@param bin string
---@return boolean
function M.executable(bin)
  return vim.fn.executable(bin) == 1
end

--- Wrap a shell command to run inside MSYS2 login bash (e.g. for plugin builds
--- on native Windows). Returns nil when no MSYS2 install is invokable.
---@param cmd string
---@param opts? { msystem?: string }
---@return string?
function M.msys2_wrap(cmd, opts)
  if not M.has_msys2 then
    return nil
  end
  opts = opts or {}
  local root = M.msys2_root
  local msystem = opts.msystem or "UCRT64"
  return string.format(
    [[%s/usr/bin/env.exe CHERE_INVOKING=1 MSYSTEM=%s %s/usr/bin/bash.exe -l -c "%s"]],
    root,
    msystem,
    root,
    cmd
  )
end

--- Resolved path for local `dev` plugins. Overridable per-machine via
--- `NVIM_DEV_PATH`; keeps the historical Windows default otherwise.
M.dev_path = vim.env.NVIM_DEV_PATH or (M.is_win_os and "K:/projects/nvim-plugins/") or "~/projects/nvim-plugins/"

--- Separator-agnostic basename without extension (fixes overseer's
--- forward-slash-only parsing on Windows paths).
---@param path string
---@return string
function M.basename(path)
  if not path or path == "" then
    return path
  end
  local base = vim.fs.basename((path:gsub("\\", "/")))
  return (base:gsub("%.%w+$", ""))
end

return M
