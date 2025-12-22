---@type LazySpec
return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false, -- self-lazy
    keys = {
      { "<C-Up>" },
      { "<C-Down>" },
      { "<C-Left>" },
      { "<C-Right>" },
      { "<leader>wj" },
      { "<leader>wk" },
      { "<leader>wl" },
      { "<leader>w;" },
    },
    opts = {},
    config = function(_, opts)
      require("smart-splits").setup(opts)
      vim.keymap.set("n", "<C-Up>", require("smart-splits").resize_up, { desc = "Resize Window Up" })
      vim.keymap.set("n", "<C-Down>", require("smart-splits").resize_down, { desc = "Resize Window Down" })
      vim.keymap.set("n", "<C-Left>", require("smart-splits").resize_left, { desc = "Resize Window Left" })
      vim.keymap.set("n", "<C-Right>", require("smart-splits").resize_right, { desc = "Resize Window Right" })
      vim.keymap.set("n", "<leader>wj", require("smart-splits").move_cursor_left, { desc = "Move to Left Window" })
      vim.keymap.set("n", "<leader>wk", require("smart-splits").move_cursor_up, { desc = "Move to Upper Window" })
      vim.keymap.set("n", "<leader>wl", require("smart-splits").move_cursor_right, { desc = "Move to Right Window" })
      vim.keymap.set("n", "<leader>w;", require("smart-splits").move_cursor_down, { desc = "Move to Lower Window" })
    end,
  },
}
