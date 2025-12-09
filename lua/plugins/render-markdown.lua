return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      overrides = {
        buftype = {
          nofile = {
            win_options = { -- disable spellcheck squiggles in documentation windows!
              spell = { default = vim.o.spell, rendered = false },
            },
          },
        },
      },
    },
  },
}
