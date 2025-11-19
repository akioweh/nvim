return {
  {
    "chrisgrieser/nvim-origami",
    event = "VeryLazy",
    -- disable vanilla auto-folding
    init = function()
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99

      -- keymaps.lua runs after plugins and will overwite these
      -- vim.keymap.set("n", "j", function()
      --   require("origami").h()
      -- end)
      -- vim.keymap.set("n", "l", function()
      --   require("origami").l()
      -- end)
      --
      -- vim.keymap.set("n", "L", function()
      --   require("origami").dollar()
      -- end)
    end,
    opts = {
      foldKeymaps = {
        setup = false,
      },
    },
  },
}
