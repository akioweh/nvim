-- Reference-screenshot tests: capture the rendered screen grid (text + highlight
-- attrs) from a child Neovim running the real config, in full-UI vs vscode mode.
-- mini.test renders to a real grid, so this exercises UI rendering that a
-- headless `+qa` smoke test cannot.
--
-- Baselines live in tests/screenshots/ (committed). Regenerate after an
-- intentional UI change with `make update-screenshots`, then commit. Screenshots
-- are nvim-version specific, so CI pins the version. The child disables lazy's
-- update checker (g:auto_update=false), so this runs offline; spawning the child
-- only needs OS permission to create a --listen socket.

local MiniTest = require("mini.test")
local child = MiniTest.new_child_neovim()

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

--- A deterministic scene: a fixed scratch buffer, notifications dismissed.
local function fixed_scene()
  child.lua([[
    pcall(function() require("snacks").notifier.hide() end)
    vim.cmd("enew")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "fn main() {", "    print(42)", "}" })
    vim.bo.modified = false
    vim.cmd("redraw")
  ]])
end

local T = MiniTest.new_set({
  hooks = {
    pre_once = function()
      vim.env.NVIM_NO_AUTO_INSTALL = "1"
    end,
    post_once = function()
      child.stop()
      vim.env.NVIM_NO_AUTO_INSTALL = nil
    end,
  },
})

T["full UI (normal mode)"] = function()
  start(false)
  fixed_scene()
  MiniTest.expect.reference_screenshot(child.get_screenshot())
end

T["stripped UI (vscode mode)"] = function()
  start(true)
  fixed_scene()
  MiniTest.expect.reference_screenshot(child.get_screenshot())
end

return T
