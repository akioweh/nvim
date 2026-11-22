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
          if vim.treesitter.get_parser(0) then
            require("treesj").join()
          else
            local count = vim.v.count
            vim.cmd.normal({ (count > 0 and tostring(count) or "") .. "J", bang = true })
          end
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
      max_join_length = 1000,
    },
  },
}
