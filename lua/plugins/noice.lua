---@type LazySpec

return {
  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
          ["vim.lsp.util.stylize_markdown"] = false,
        },
      },
    },
  },
}
