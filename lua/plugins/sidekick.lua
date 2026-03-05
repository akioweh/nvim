---@type LazySpec

return {
  {
    "folke/sidekick.nvim",
    optional = true,
    keys = {
      { "<tab>", false },
      { "<c-y>", LazyVim.cmp.map({ "ai_nes" }, "<c-y>"), mode = { "n" }, expr = true },
    },
  },
}
