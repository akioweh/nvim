---@type LazySpec
return {
  {
    "Wansmer/treesj",
    keys = {
      {
        "<space>m",
        function()
          require("treesj").toggle()
        end,
        mode = { "n", "x" },
      },
      {
        "<space>j",
        function()
          require("treesj").join()
        end,
        mode = { "n", "x" },
      },
      {
        "<space>J",
        function()
          require("treesj").split()
        end,
        mode = { "n", "x" },
      },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
    },
  },
}
