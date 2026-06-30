--- vscode-neovim profile.
---
--- When Neovim runs embedded in VSCode (`vim.g.vscode` is set), VSCode owns the
--- UI, so the heavy editor-UI plugins are stripped while editing / motion /
--- treesitter / LSP stay. This is one auditable list that merges by plugin name
--- (lazy spec-merge), so the individual plugin specs need no edits. `optional`
--- means an entry that isn't otherwise installed is a harmless no-op.
---
--- Snacks is intentionally NOT disabled (keymaps.lua, visual-whitespace and
--- LazyVim core depend on it); instead its UI-heavy features are turned off.

local platform = require("util.platform")

if not platform.is_vscode then
  return {}
end

-- Whole plugins safe to remove under vscode-neovim (names verified against the
-- live lazy config; keep in sync with lazy-lock.json).
local disable = {
  "akinsho/bufferline.nvim",
  "nvim-lualine/lualine.nvim",
  "nvim-neo-tree/neo-tree.nvim",
  "folke/noice.nvim",
  "petertriho/nvim-scrollbar",
  "saghen/blink.indent",
  "mcauley-penney/visual-whitespace.nvim",
  "unblevable/quick-scope",
  "MeanderingProgrammer/render-markdown.nvim",
  "hat0uma/csvview.nvim",
  "DrKJeff16/project.nvim",
  "akinsho/toggleterm.nvim",
}

---@type LazySpec
local specs = {}
for _, repo in ipairs(disable) do
  specs[#specs + 1] = { repo, optional = true, enabled = false }
end

-- snacks stays loaded but with UI-heavy features off.
specs[#specs + 1] = {
  "folke/snacks.nvim",
  optional = true,
  opts = {
    dashboard = { enabled = false },
    scroll = { enabled = false },
    animate = { enabled = false },
    scratch = { enabled = false },
    words = { enabled = false },
    indent = { enabled = false },
    notifier = { enabled = false },
    statuscolumn = { enabled = false },
  },
}

return specs
