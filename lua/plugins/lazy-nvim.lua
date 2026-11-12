---@type LazySpec
return {
  {
    "folke/lazy.nvim",
    optional = true,
    init = function()
      -- lazy.nvim is already loaded so we can't use spec.keys
      vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy", silent = true })
    end,
  },
}
