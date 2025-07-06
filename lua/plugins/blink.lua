return {
  "saghen/blink.cmp",
  opts = {
    appearance = {
      nerd_font_variant = "normal",
    },
    -- keymap = {
    --   preset = "super-tab",
    -- },
    keymap = {
      preset = "none",
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
      ["<CR>"] = false,
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide" },
    },
    completion = {
      list = {
        selection = {
          auto_insert = true,
          preselect = function(ctx)
            return not require("blink.cmp").snippet_active({ direction = 1 })
          end,
        },
      },
    },
  },
}
