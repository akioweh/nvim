return {
  {
    "stevearc/overseer.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
    },
    opts = {
      templates = {
        "builtin",
        "user.cpp_single",
        "user.cpp2",
        "user.cpp_compile",
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
