---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "Grey" })
          vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true, sp = "Grey" })
        end,
      })
    end,
    opts = {},
  },
}
