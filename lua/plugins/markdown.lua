if false then
  require("render-markdown")
end

---@type LazySpec
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    init = function()
      -- highlighting for the custom tree-sitter conceal queries
      vim.api.nvim_set_hl(0, "@conceal.escape", { link = "Normal" })
    end,
    ---@type render.md.UserConfig
    opts = {
      completions = {
        lsp = {
          enabled = true,
        },
      },
      overrides = {
        buftype = {
          nofile = {
            win_options = { -- disable spellcheck squiggles in documentation popups!
              spell = { default = vim.o.spell, rendered = false },
            },
          },
          help = {
            win_options = {
              spell = { default = vim.o.spell, rendered = false },
            },
          },
        },
      },
      win_options = {
        conceallevel = {
          rendered = 2,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint.yaml" },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", vim.fn.stdpath("config") .. "/.markdownlint.yaml" },
        },
      },
    },
  },
}
