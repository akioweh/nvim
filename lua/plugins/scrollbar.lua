if false then
  require("scrollbar")
end

---@type LazySpec
return {
  {
    "petertriho/nvim-scrollbar",
    branch = "refactor/v2",
    lazy = true,
    event = "LazyFile",
    dependencies = {
      "lewis6991/gitsigns.nvim",
    },
    ---@type ScrollbarUserConfig
    opts = {
      exclude = {
        filetypes = {
          ["neo-tree"] = true,
        },
      },
      scrollbar = {
        preset = "intellij",
        unit = "screenline",
        throttle_ms = 20,
      },
      providers = {
        cursor = false,
        gitsigns = true,
      },
      marks = {
        GitAdd = {
          text = "▕",
        },
        GitChange = {
          text = "▕",
        },
      },
    },
  },
}
