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
      input = { enabled = false },
      words = {
        enabled = false,
        -- debounce = 25,
        -- modes = { "n", "c" },
      },
      image = {
        enabled = true,
        math = { enabled = false },
      },
      styles = {
        -- fullscreen lazygit
        lazygit = {
          width = 0,
          height = 0,
          border = false,
          backdrop = false,
        },
      },
    },
  },
}
