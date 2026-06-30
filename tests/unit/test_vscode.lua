-- Deterministic, in-process test of the vscode-neovim profile's spec output.
-- (lazy.nvim's spec-merge that actually applies enabled=false is upstream-tested;
-- the end-to-end "lazy disabled it" check lives in tests/integration.)

local MiniTest = require("mini.test")
local eq = MiniTest.expect.equality
local platform = require("util.platform")

--- Load plugins/vscode.lua fresh with `platform.is_vscode` forced.
local function load_spec(is_vscode)
  local saved = platform.is_vscode
  platform.is_vscode = is_vscode
  package.loaded["plugins.vscode"] = nil
  local spec = require("plugins.vscode")
  package.loaded["plugins.vscode"] = nil
  platform.is_vscode = saved
  return spec
end

local T = MiniTest.new_set()

T["returns empty list outside vscode"] = function()
  eq(load_spec(false), {})
end

T["disables curated UI plugins under vscode"] = function()
  local spec = load_spec(true)
  local byrepo = {}
  for _, s in ipairs(spec) do
    byrepo[s[1]] = s
  end

  for _, repo in ipairs({
    "akinsho/bufferline.nvim",
    "nvim-neo-tree/neo-tree.nvim",
    "folke/noice.nvim",
    "akinsho/toggleterm.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
  }) do
    eq(byrepo[repo] ~= nil, true)
    eq(byrepo[repo].enabled, false)
    eq(byrepo[repo].optional, true) -- no-op if the plugin isn't installed
  end
end

T["keeps snacks loaded but soft-configures UI off"] = function()
  local spec = load_spec(true)
  local snacks
  for _, s in ipairs(spec) do
    if s[1] == "folke/snacks.nvim" then
      snacks = s
    end
  end
  eq(snacks ~= nil, true)
  eq(snacks.enabled, nil) -- NOT disabled
  eq(snacks.opts.dashboard.enabled, false)
  eq(snacks.opts.scroll.enabled, false)
  eq(snacks.opts.indent.enabled, false)
end

return T
