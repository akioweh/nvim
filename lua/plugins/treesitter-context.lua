return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = function(_, opts)
      vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "none" })
      vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "Grey", bg = "none" })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { underline = true, sp = "Grey" })
    end,
  },
}
