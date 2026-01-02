if false then
  require("snacks")
end

---@type LazySpec
return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      animate = { enabled = false }, -- how dare you try animate a TUI >:(
      scroll = { enabled = false }, -- smooth scrolling
      dashboard = { enabled = false },
      words = {
        enabled = false,
        -- debounce = 25,
        -- modes = { "n", "c" },
      },
    },
  },
}
