---@type LazySpec
return {
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = "close",
          },
        },
      },
    },
  },
}
