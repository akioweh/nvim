return {
  {
    "stevearc/overseer.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
    },
    opts = {
      templates = {
        "builtin",
        "user",
      },
      -- log = {
      --   {
      --     type = "file",
      --     filename = "overseer.log",
      --     level = vim.log.levels.TRACE, -- or TRACE for max verbosity
      --   },
      -- },
    },
  },
}
