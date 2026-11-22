---@type LazySpec
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft.c = { "uncrustify" }
      opts.formatters_by_ft.cpp = { "uncrustify" }
      opts.formatters.uncrustify = {
        cwd = require("conform.util").root_file({ "uncrustify.cfg" }),
        require_cwd = true,
      }
    end,
  },
}
