---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    init = function()
      -- move (swap) function parameters
      local ts_s = require("nvim-treesitter-textobjects.swap")
      vim.keymap.set("n", "<M-f>", function()
        ts_s.swap_next("@parameter.inner")
      end)
      vim.keymap.set("n", "<M-s>", function()
        ts_s.swap_previous("@parameter.inner")
      end)
      local c_o = vim.api.nvim_replace_termcodes("<C-o>", true, false, true)
      vim.keymap.set("i", "<M-f>", function()
        vim.api.nvim_feedkeys(c_o, "n", false)
        ts_s.swap_next("@parameter.inner")
      end)
      vim.keymap.set("i", "<M-s>", function()
        vim.api.nvim_feedkeys(c_o, "n", false)
        ts_s.swap_previous("@parameter.inner")
      end)
    end,
    opts = {},
  },
}
