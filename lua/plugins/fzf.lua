---@type LazySpec
return {
  {
    "ibhagwan/fzf-lua",
    optional = true,
    opts = { "hide" },
    keys = {
      {
        "<Esc>",
        "<C-\\><C-n><C-w>c",
        ft = "fzf",
        mode = "t",
        silent = true,
        nowait = true,
      },
    },
  },
}
