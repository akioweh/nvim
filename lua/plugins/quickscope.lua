return {
  {
    "unblevable/quick-scope",
    init = function()
      vim.g.qs_buftype_blacklist = { "terminal", "nofile" }
      vim.g.qs_filetype_blacklist = { "dashboard", "NvimTree", "neo-tree", "Trouble", "help", "alpha" }
    end,
  },
}
