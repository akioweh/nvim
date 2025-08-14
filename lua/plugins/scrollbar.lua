return {
  {
    "petertriho/nvim-scrollbar",
    lazy = true,
    event = "LazyFile",
    dependencies = {
      "lewis6991/gitsigns.nvim",
    },
    opts = {
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
