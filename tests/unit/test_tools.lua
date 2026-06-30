local MiniTest = require("mini.test")
local eq = MiniTest.expect.equality
local platform = require("util.platform")
local tools = require("util.tools")

local tmp = vim.fn.getcwd() .. "/.tests/tool-overrides-test.json"
local saved = {}

--- Make `platform.executable` report exactly the binaries in `set` as present.
local function set_present(set)
  platform.executable = function(bin)
    return set[bin] == true
  end
end

--- Write a synthetic override file and refresh the cache.
local function write_overrides(tbl)
  vim.fn.mkdir(vim.fn.fnamemodify(tmp, ":h"), "p")
  vim.fn.writefile({ vim.json.encode({ version = 1, force = tbl.force or {}, cache = tbl.cache or {} }) }, tmp)
  tools._reset()
end

local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      saved.exec = platform.executable
      saved.strategy = vim.g.tools_strategy
      saved.path = tools.override_path
      tools.override_path = tmp
      vim.fn.delete(tmp)
      tools._reset()
      vim.g.tools_strategy = nil
    end,
    post_case = function()
      platform.executable = saved.exec
      vim.g.tools_strategy = saved.strategy
      tools.override_path = saved.path
      tools._reset()
      vim.fn.delete(tmp)
    end,
  },
})

T["strategy defaults to smart"] = function()
  eq(tools.strategy(), "smart")
  eq(tools.mason_path_mode(), "append")
end

T["strategy mason installs everything"] = function()
  vim.g.tools_strategy = "mason"
  eq(tools.strategy(), "mason")
  eq(tools.mason_path_mode(), "prepend")
  set_present({ stylua = true }) -- present, but mason manages it anyway
  eq(tools.use_mason("stylua"), true)
end

T["smart"] = MiniTest.new_set()

T["smart"]["system present -> skip mason"] = function()
  set_present({ stylua = true })
  eq(tools.use_mason("stylua"), false)
end

T["smart"]["system absent -> use mason"] = function()
  set_present({})
  eq(tools.use_mason("stylua"), true)
end

T["bin resolution"] = function()
  eq(tools.bin("lua_ls"), "lua-language-server")
  eq(tools.bin("tree-sitter-cli"), "tree-sitter")
  eq(tools.bin("hls"), "haskell-language-server-wrapper")
  eq(tools.bin("stylua"), "stylua") -- default: key == bin
end

T["bin resolution drives system probe"] = function()
  set_present({ ["lua-language-server"] = true })
  eq(tools.use_mason("lua_ls"), false) -- lua_ls binary is present
  set_present({})
  eq(tools.use_mason("lua_ls"), true)
end

T["override"] = MiniTest.new_set()

T["override"]["force mason ignores a present system tool"] = function()
  write_overrides({ force = { stylua = "mason" } })
  set_present({ stylua = true })
  eq(tools.use_mason("stylua"), true)
end

T["override"]["force system ignores an absent tool"] = function()
  write_overrides({ force = { stylua = "system" } })
  set_present({})
  eq(tools.use_mason("stylua"), false)
end

T["override"]["unparseable file is ignored gracefully"] = function()
  vim.fn.mkdir(vim.fn.fnamemodify(tmp, ":h"), "p")
  vim.fn.writefile({ "{ not json" }, tmp)
  tools._reset()
  set_present({})
  eq(tools.use_mason("stylua"), true) -- falls back to detection, no crash
end

T["dap alias"] = MiniTest.new_set()

T["dap alias"]["python resolves to debugpy (cached present) -> skip mason"] = function()
  write_overrides({ cache = { debugpy = true } })
  set_present({})
  eq(tools.use_mason(tools.dap_alias["python"]), false)
end

T["dap alias"]["debugpy cached absent -> use mason"] = function()
  write_overrides({ cache = { debugpy = false } })
  set_present({})
  eq(tools.use_mason("debugpy"), true)
end

return T
