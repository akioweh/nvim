---@type LazySpec
return {
  {
    "akinsho/bufferline.nvim",
    optional = true,
    keys = {
      { "<S-h>", false },
      { "<S-l>", false },
      { "<M-j>", "<cmd>BufferLineCyclePrev<cr>", mode = { "n", "x" }, desc = "Prev Buffer" },
      { "<M-l>", "<cmd>BufferLineCycleNext<cr>", mode = { "n", "x" }, desc = "Next Buffer" },
      { "<M-j>", "<C-o><cmd>BufferLineCyclePrev<cr>", mode = { "i", "s" }, desc = "Prev Buffer" },
      { "<M-l>", "<C-o><cmd>BufferLineCycleNext<cr>", mode = { "i", "s" }, desc = "Next Buffer" },
      { "<M-S-j>", "<cmd>BufferLineMovePrev<cr>", mode = { "n", "x" }, desc = "Move Buffer Left" },
      { "<M-S-l>", "<cmd>BufferLineMoveNext<cr>", mode = { "n", "x" }, desc = "Move Buffer Right" },
      { "<M-S-j>", "<C-o><cmd>BufferLineMovePrev<cr>", mode = { "i", "s" }, desc = "Move Buffer Left" },
      { "<M-S-l>", "<C-o><cmd>BufferLineMoveNext<cr>", mode = { "i", "s" }, desc = "Move Buffer Right" },
    },
  },
}
