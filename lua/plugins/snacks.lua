return {
  {
    "folke/snacks.nvim",
    init = function(_)
      vim.g.snacks_animate = false
    end,
    opts = {
      picker = {
        sources = {
          explorer = {
            layout = {
              layout = {
                width = 28,
              },
            },
          },
        },
      },
    },
  },
}
