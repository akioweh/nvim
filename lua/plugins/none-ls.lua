---@type LazySpec
return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        -- nls.builtins.code_actions.proselint.with({ filetypes = { "tex", "markdown", "typst" } }),
        -- nls.builtins.code_actions.textlint,
        nls.builtins.completion.spell.with({
          filetypes = { "markdown", "tex", "typst", "text", "gitcommit", "gitrebase" },
        }),
        nls.builtins.completion.tags,
        nls.builtins.diagnostics.actionlint,
        -- nls.builtins.diagnostics.alex,
        nls.builtins.diagnostics.checkmake,
        nls.builtins.diagnostics.checkstyle,
        nls.builtins.diagnostics.cmake_lint,
        nls.builtins.diagnostics.dotenv_linter,
        -- nls.builtins.diagnostics.editorconfig_checker,
        -- nls.builtins.diagnostics.proselint.with({ filetypes = { "tex", "markdown", "typst" } }),
        nls.builtins.diagnostics.vacuum,
        -- nls.builtins.diagnostics.vale.with({ filetypes = { "tex", "markdown", "asciidoc", "typst" } }),
        nls.builtins.hover.dictionary,
        nls.builtins.hover.printenv,
      })
    end,
  },
}
