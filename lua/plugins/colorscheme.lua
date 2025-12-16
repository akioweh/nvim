---@type LazySpec
return {
  { "tiagovla/tokyodark.nvim", lazy = true },
  { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = true },
  { "xiantang/darcula-dark.nvim", lazy = true },
  { "olimorris/onedarkpro.nvim", lazy = true },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavor = "mocha",
      transparent_background = true,
      auto_integrations = true,
    },
  },
  {
    "akioweh/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
