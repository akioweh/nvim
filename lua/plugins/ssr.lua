---@type LazySpec
return {
  {
    "cshuaimin/ssr.nvim",
    lazy = false, -- self-lazy (config does not load)
    keys = {
      {
        "<leader>sf",
        function()
          require("ssr").open()
        end,
        desc = "Structural Search and Replace",
      },
    },
    opts = {},
  },
}
