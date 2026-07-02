--- vscode-neovim profile (whitelist), modeled on LazyVim's
--- `lazyvim.plugins.extras.vscode`. LazyVim DOES auto-load that extra when
--- `vim.g.vscode` is set (xtras.lua inserts it at extras[1]) — but the extra
--- `require("vscode")`s the vscode-neovim runtime module at load, which does NOT
--- exist under headless Neovim. So the extra errors out before setting its
--- `defaults.cond` and is a silent no-op in tests/CI — it gates nothing there.
---
--- Hence we keep our OWN self-contained whitelist (crucially, NO `require("vscode")`),
--- so the profile works and is TESTABLE both in real VSCode and headless. It is
--- imported after `lazyvim.plugins`, so its `defaults.cond` overrides the extra's.
--- Do not "slim" this to just `vscode = true` markers + delegate to the extra: that
--- silently drops all gating under headless CI. (For the effective plugin set the
--- two whitelists are equivalent anyway; the only real delta is ultimate-autopair,
--- which we use instead of mini.pairs.)
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
