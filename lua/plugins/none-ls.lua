local nls = require("null-ls")

---@type LazySpec
return {
  {
    "nvimtools/none-ls.nvim",
    opts = {
      sources = {
        -- nls.builtins.code_actions.proselint.with({ filetypes = { "tex", "markdown", "typst" } }),
        -- nls.builtins.code_actions.textlint,
        nls.builtins.completion.spell,
        nls.builtins.completion.tags,
        nls.builtins.diagnostics.actionlint,
        -- nls.builtins.diagnostics.alex,
        nls.builtins.diagnostics.checkmake,
        nls.builtins.diagnostics.checkstyle,
        nls.builtins.diagnostics.cmake_lint,
        nls.builtins.diagnostics.dotenv_linter,
        -- nls.builtins.diagnostics.editorconfig_checker,
        -- nls.builtins.diagnostics.proselint.with({ filetypes = { "tex", "markdown", "typst" } }),
        -- nls.builtins.diagnostics.vacuum,
        -- nls.builtins.diagnostics.vale.with({ filetypes = { "tex", "markdown", "asciidoc", "typst" } }),
        nls.builtins.hover.dictionary,
        nls.builtins.hover.printenv,
      },
    },
  },
}
