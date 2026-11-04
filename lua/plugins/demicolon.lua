---@type LazySpec
return {
  {
    "mawkler/demicolon.nvim",
    event = "User LazyVimKeymaps",
    ---@type demicolon.options
    opts = {
      keymaps = {
        horizontal_motions = false,
        change_list_jumps = false,
        repeat_motions = false,
        disabled_keys = {
          "p", -- builtin: paste with adjusted indent
          "I", -- builtin: list lines containing identifier
          "i", -- builtin: show first line containing identifier
          " ", -- builtin: insert a blank line
          "y", -- Yanky: cycle yank history
          "T", -- Yanky (custom): put indented before/after cursor
        },
      },
    },
    config = function(_, opts)
      require("demicolon").setup(opts)

      local map = vim.keymap.set
      local motion_modes = { "n", "x", "o" }
      local jump = require("demicolon.jump")
      local repeat_jump = require("demicolon.repeat_jump")

      map(motion_modes, ".", jump.horizontal_jump("f"), { expr = true, desc = "Find Forward" })
      map(motion_modes, "m", jump.horizontal_jump("F"), { expr = true, desc = "Find Backward" })
      map(motion_modes, ">", jump.horizontal_jump("t"), { expr = true, desc = "Till Forward" })
      map(motion_modes, "M", jump.horizontal_jump("T"), { expr = true, desc = "Till Backward" })

      map(motion_modes, ",", repeat_jump.next, { desc = "Repeat Motion" })
      map(motion_modes, "<", repeat_jump.prev, { desc = "Repeat Motion (Opposite)" })

      map("n", "g.", jump.change_list_jump("g,"), { desc = "Next Change" })
      map("n", "gm", jump.change_list_jump("g;"), { desc = "Prev Change" })
    end,
  },
}
