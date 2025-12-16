---@type LazySpec
return {
  {
    "hat0uma/csvview.nvim",
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = {
        async_chunksize = 50,
        comments = { "#", "//" },
        max_lookahead = 150,
      },
      view = {
        min_column_width = 3,
        spacing = 2,
        display_mode = "border",
      },

      --- @type CsvView.Options.Keymaps
      keymaps = {
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "of", mode = { "o", "x" } },
        -- Excel-like navigation
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },

      --- Actions for keymaps.
      ---@type CsvView.Options.Actions
    },
  },
}
