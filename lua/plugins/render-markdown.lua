return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      completions = {
        lsp = {
          enabled = true,
        },
      },
      overrides = {
        buftype = {
          nofile = {
            win_options = { -- disable spellcheck squiggles in documentation windows!
              spell = { default = vim.o.spell, rendered = false },
            },
          },
        },
        filetype = { -- doesn't seem to work but whatever?
          ["blink-cmp-documentation"] = {
            render_modes = true,
          },
          ["blink-cmp-signature"] = {
            render_modes = true,
          },
        },
      },
    },
  },
}
