if false then
  require("render-markdown")
end

---@type LazySpec
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
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
