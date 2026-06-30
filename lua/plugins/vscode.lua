--- vscode-neovim profile (whitelist), modeled on LazyVim's
--- `lazyvim.plugins.extras.vscode`. That extra is NOT auto-loaded and isn't in
--- our lazyvim.json, so we roll our own based on its tried-and-tested list.
---
--- Under vim.g.vscode, VSCode owns the UI, so only editing-essential plugins load
--- (everything else is excluded via `Config.options.defaults.cond`). This is a
--- whitelist, not a blacklist: add a plugin back by listing it here, or by setting
--- `vscode = true` on its own spec.

local platform = require("util.platform")
if not platform.is_vscode then
  return {}
end

-- Names exactly as lazy sees them. Based on LazyVim's vscode extra, adapted to this
-- config: ultimate-autopair instead of mini.pairs; the j;kl motion layout needs
-- treesitter-textobjects + mini.ai; paste (t/T) needs yanky.
local enabled = {
  "LazyVim",
  "lazy.nvim",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "mini.ai",
  "mini.surround",
  "mini.move",
  "mini.comment",
  "ultimate-autopair.nvim",
  "snacks.nvim",
  "yanky.nvim",
  "dial.nvim",
  "vim-repeat",
  "ts-comments.nvim",
  "nvim-ts-context-commentstring",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name) or plugin.vscode == true
end
vim.g.snacks_animate = false

return {
  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      notifier = { enabled = false },
      picker = { enabled = false },
      quickfile = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
    },
  },
  {
    -- VSCode does syntax highlighting; keep treesitter for textobjects only.
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { highlight = { enable = false } },
  },
}
