return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = function(_, opts)
      opts.appearance = opts.appearance or {}
      opts.appearance.nerd_font_variant = "normal"
      -- override lazyvim stuff
      opts.keymap = {
        preset = "super-tab",
      }
      opts.completion = opts.completion or {}
      opts.completion.list = opts.completion.list or {}
      opts.completion.list.selection = {
        auto_insert = true,
        preselect = function(ctx)
          return not require("blink.cmp").snippet_active({ direction = 1 })
        end,
      }
      opts.signature = { enabled = true }
      opts.cmdline = {
        completion = { menu = { auto_show = true } },
      }
    end,
  },
}
