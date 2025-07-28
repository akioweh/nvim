return {
  { "tiagovla/tokyodark.nvim" },
  { "bluz71/vim-moonfly-colors", name = "moonfly" },
  { "xiantang/darcula-dark.nvim" },
  {
    "olimorris/onedarkpro.nvim",
    -- lazy = false,
    -- priority = 1000,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavor = "mocha",
      transparent_background = true,
    },
  },
  {
    "akioweh/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
