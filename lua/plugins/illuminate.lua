---@type LazySpec
return {
  {
    "RRethy/vim-illuminate",
    opts = {
      delay = 10,
      -- some lsps are slow.
      -- if the lsp's highlighting calls are slower than "delay",
      -- the highlighting will flash while moving between the same identifier.
      -- but if "delay" is too large, (or if the lsp is just so slow),
      -- the entire experience feels sluggish.
      -- So, we trade lsp's accuracy for treesitter's speed for the worst lsps
      filetype_overrides = {
        -- lua = { -- lua_ls, waaay too slow?!
        --   providers = { "treesitter" },
        -- },
        python = { -- pylsp; basedpyright is faster i think
          delay = 55,
        },
      },
    },
  },
}
