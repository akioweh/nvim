local MiniTest = require("mini.test")
local eq = MiniTest.expect.equality
local platform = require("util.platform")

local T = MiniTest.new_set()

--- Build a synthetic `util.platform.Inputs` table.
---@param o? { win?: boolean, env?: table, shell?: string, bash_exepath?: string, existing_roots?: string[], vscode?: any }
local function inputs(o)
  o = o or {}
  return {
    has = function(f)
      return (o.win and f == "win32") and 1 or 0
    end,
    env = o.env or {},
    shell = o.shell or "/usr/bin/zsh",
    exepath = function(_)
      return o.bash_exepath or ""
    end,
    fs_stat = function(p)
      for _, root in ipairs(o.existing_roots or {}) do
        if p == root .. "/usr/bin/bash.exe" or p == root .. "/usr/bin/pacman.exe" then
          return { type = "file" }
        end
      end
      return nil
    end,
    vscode = o.vscode,
  }
end

T["env"] = MiniTest.new_set()

T["env"]["linux when not windows"] = function()
  local d = platform._detect(inputs({}))
  eq(d.env, "linux")
  eq(d.is_linux, true)
  eq(d.is_windows, false)
  eq(d.is_msys2, false)
  eq(d.is_win_os, false)
  eq(d.is_unix, true)
  eq(d.sep, "/")
  eq(d.exe_suffix, "")
  eq(d.has_msys2, false)
  eq(d.msys2_root, nil)
end

T["env"]["native windows (no MSYSTEM, non-msys shell)"] = function()
  local d = platform._detect(inputs({ win = true, shell = "C:/Windows/System32/cmd.exe" }))
  eq(d.env, "windows")
  eq(d.is_windows, true)
  eq(d.is_msys2, false)
  eq(d.is_win_os, true)
  eq(d.is_unix, false)
  eq(d.sep, "\\")
  eq(d.exe_suffix, ".exe")
end

T["env"]["msys2 via MSYSTEM env var"] = function()
  local d = platform._detect(inputs({
    win = true,
    env = { MSYSTEM = "UCRT64" },
    shell = "C:/msys64/usr/bin/bash.exe",
  }))
  eq(d.env, "msys2")
  eq(d.is_msys2, true)
  eq(d.is_windows, false)
  eq(d.is_win_os, true) -- still the Windows OS
  eq(d.is_unix, true) -- but unix-like runtime
end

T["env"]["msys2 via msys bash shell even without MSYSTEM"] = function()
  local d = platform._detect(inputs({ win = true, shell = "C:/msys64/usr/bin/bash.exe" }))
  eq(d.env, "msys2")
  eq(d.shell.is_msys_bash, true)
end

T["env"]["git-for-windows bash is NOT msys2"] = function()
  local d = platform._detect(inputs({ win = true, shell = "C:/Program Files/Git/usr/bin/bash.exe" }))
  eq(d.shell.is_msys_bash, false)
  eq(d.env, "windows")
end

T["msys2 availability"] = MiniTest.new_set()

T["msys2 availability"]["installed but running native -> windows env, has_msys2"] = function()
  local d = platform._detect(inputs({
    win = true,
    shell = "pwsh",
    existing_roots = { "C:/msys64" },
  }))
  eq(d.env, "windows") -- not inside msys
  eq(d.has_msys2, true) -- but msys2 is installed & invokable
  eq(d.msys2_root, "C:/msys64")
end

T["msys2 availability"]["NVIM_MSYS2_ROOT override wins"] = function()
  local d = platform._detect(inputs({
    win = true,
    env = { NVIM_MSYS2_ROOT = "D:\\tools\\msys2" },
    existing_roots = { "D:/tools/msys2" },
  }))
  eq(d.msys2_root, "D:/tools/msys2")
  eq(d.has_msys2, true)
end

T["msys2 availability"]["MSYSTEM_PREFIX points one level under root"] = function()
  local d = platform._detect(inputs({
    win = true,
    env = { MSYSTEM = "UCRT64", MSYSTEM_PREFIX = "C:/msys64/ucrt64" },
    existing_roots = { "C:/msys64" },
  }))
  eq(d.msys2_root, "C:/msys64")
end

T["msys2 availability"]["none found on linux"] = function()
  local d = platform._detect(inputs({ existing_roots = { "C:/msys64" } }))
  eq(d.has_msys2, false)
  eq(d.msys2_root, nil)
end

T["vscode"] = MiniTest.new_set()

T["vscode"]["is_vscode true when vim.g.vscode set"] = function()
  eq(platform._detect(inputs({ vscode = 1 })).is_vscode, true)
end

T["vscode"]["is_vscode false otherwise"] = function()
  eq(platform._detect(inputs({})).is_vscode, false)
end

T["shell kinds"] = function()
  local function kind(s)
    return platform._detect(inputs({ shell = s })).shell.kind
  end
  eq(kind("pwsh"), "pwsh")
  eq(kind("C:/Program Files/PowerShell/7/pwsh.exe"), "pwsh")
  eq(kind("/usr/bin/bash"), "bash")
  eq(kind("/bin/zsh"), "zsh")
  eq(kind("/usr/bin/fish"), "fish")
  eq(kind("C:/Windows/System32/cmd.exe"), "cmd")
  eq(kind("/bin/sh"), "sh")
  eq(kind("/weird/thing"), "unknown")
end

T["basename"] = function()
  eq(platform.basename("foo/bar/baz.cpp"), "baz")
  eq(platform.basename("C:\\x\\y\\main.cc"), "main")
  eq(platform.basename("noext"), "noext")
end

return T
