---@type LazySpec
return {
  {
    "petertriho/nvim-scrollbar",
    lazy = true,
    event = "LazyFile",
    dependencies = {
      "lewis6991/gitsigns.nvim",
    },
    opts = {
      throttle_ms = 20,
      handle = {
        blend = 30,
        highlight = "ScrollbarHandle",
      },
      handlers = {
        cursor = false,
        gitsigns = true,
      },
      marks = {
        GitAdd = {
          text = "│",
        },
        GitChange = {
          text = "│",
        },
      },
    },
  },
}
