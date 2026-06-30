local MiniTest = require("mini.test")
local eq = MiniTest.expect.equality
local platform = require("util.platform")
local ctx = require("util.context")

local saved = {}

local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      saved.is_vscode = platform.is_vscode
      saved.env = platform.env
      saved.exec = platform.executable
    end,
    post_case = function()
      platform.is_vscode = saved.is_vscode
      platform.env = saved.env
      platform.executable = saved.exec
    end,
  },
})

T["not_vscode"] = function()
  platform.is_vscode = false
  eq(ctx.not_vscode()(), true)
  platform.is_vscode = true
  eq(ctx.not_vscode()(), false)
end

T["on_env"] = function()
  platform.env = "linux"
  eq(ctx.on_env("linux", "msys2")(), true)
  eq(ctx.on_env("windows")(), false)
  platform.env = "windows"
  eq(ctx.on_env("windows")(), true)
  eq(ctx.on_env("linux", "msys2")(), false)
end

T["if_executable"] = function()
  platform.executable = function(b)
    return b == "rg"
  end
  eq(ctx.if_executable("rg")(), true)
  eq(ctx.if_executable("does-not-exist")(), false)
end

T["if_root"] = function()
  -- The test cwd is the repo root, which contains a Makefile.
  eq(ctx.if_root({ "Makefile" })(), true)
  eq(ctx.if_root({ "definitely-not-a-real-marker-xyz" })(), false)
end

T["has_tool: system present short-circuits"] = function()
  platform.executable = function(b)
    return b == "lua-language-server"
  end
  eq(ctx.has_tool("lua_ls")(), true) -- lua_ls binary is lua-language-server
end

return T
