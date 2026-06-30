-- End-to-end: spawn a child Neovim running the REAL user config, with and
-- without vscode-neovim emulation (`g:vscode`), and assert lazy's resulting
-- plugin enabled-state. This proves the vscode profile actually takes effect
-- (not just that vscode.lua returns the right table — that's tests/unit).

local MiniTest = require("mini.test")
local eq = MiniTest.expect.equality

local child = MiniTest.new_child_neovim()

--- Restart the child running the real config. mini.test starts children with
--- `--clean` (which drops the config dir from 'rtp'), so prepend it back; then
--- `-u init.lua` boots the real config. `g:vscode` is set before init to emulate
--- vscode-neovim.
local function start(vscode)
  local cwd = vim.fn.getcwd()
  -- disable lazy's update checker so the child stays fully offline (no net hang)
  local args = { "--cmd", "set rtp^=" .. cwd, "--cmd", "let g:auto_update = v:false" }
  if vscode then
    vim.list_extend(args, { "--cmd", "let g:vscode = 1" })
  end
  vim.list_extend(args, { "-u", cwd .. "/init.lua" })
  child.restart(args, { connection_timeout = 60000 })
end

--- Is the plugin present in lazy's enabled set?
local function enabled(name)
  return child.lua_get(("require('lazy.core.config').plugins[%q] ~= nil"):format(name))
end

local UI_PLUGINS = {
  "bufferline.nvim",
  "neo-tree.nvim",
  "noice.nvim",
  "toggleterm.nvim",
  "nvim-scrollbar",
}

local T = MiniTest.new_set({
  hooks = {
    -- Children inherit this env: no Mason auto-install, so the heavy real config
    -- loads fast and works offline (we only assert plugin enabled-state here).
    pre_once = function()
      vim.env.NVIM_NO_AUTO_INSTALL = "1"
    end,
    post_once = function()
      child.stop()
      vim.env.NVIM_NO_AUTO_INSTALL = nil
    end,
  },
})

T["normal mode keeps UI plugins + snacks enabled"] = function()
  start(false)
  eq(enabled("snacks.nvim"), true)
  for _, name in ipairs(UI_PLUGINS) do
    eq(enabled(name), true)
  end
end

T["vscode mode disables UI plugins but keeps snacks"] = function()
  start(true)
  eq(child.lua_get("vim.g.vscode"), 1)
  eq(child.lua_get("require('util.platform').is_vscode"), true)
  eq(enabled("snacks.nvim"), true) -- snacks stays loaded (soft-configured)
  for _, name in ipairs(UI_PLUGINS) do
    eq(enabled(name), false)
  end
end

return T
