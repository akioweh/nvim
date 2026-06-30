---@type LazySpec
return {
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")

      -- Drop any source whose backing CLI isn't on PATH (e.g. fish/actionlint on
      -- a machine without them). Pure-lua sources have no `command` and stay.
      opts.sources = vim.tbl_filter(function(s)
        local cmd = s and s._opts and s._opts.command
        -- Keep pure-lua sources (no command) and any with a function-valued
        -- command; only drop string-command tools that aren't on PATH.
        return type(cmd) ~= "string" or vim.fn.executable(cmd) == 1
      end, {
        nls.builtins.diagnostics.fish,
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
