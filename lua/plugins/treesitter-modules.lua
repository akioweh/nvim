return {
  {
    "MeanderingProgrammer/treesitter-modules.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ---@module 'treesitter-modules'
    ---@type ts.mod.UserConfig
    opts = {
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "e",
          node_incremental = "e",
          scope_incremental = false,
          node_decremental = "E",
        },
      },
    },
  },
}
