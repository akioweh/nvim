return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      open_mapping = [[<M-t>]],
      winbar = {
        enabled = true,
      },
    },
  },
  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      terminal = { enabled = false },
    },
  },
}
