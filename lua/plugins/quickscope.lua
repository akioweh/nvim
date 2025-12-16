---@type LazySpec
return {
  {
    "unblevable/quick-scope",
    lazy = true,
    event = "LazyFile",
    init = function()
      vim.g.qs_buftype_blacklist = { "terminal", "nofile" }
      vim.g.qs_filetype_blacklist = { "dashboard", "NvimTree", "neo-tree", "Trouble", "help", "alpha" }

      local set_colors = function()
        vim.api.nvim_set_hl(
          0,
          "QuickScopePrimary",
          { sp = "#ffffff", underline = true, bold = true, ctermfg = 155, force = true }
        )
        vim.api.nvim_set_hl(0, "QuickScopeSecondary", { sp = "#ff0000", underline = true, force = true })
      end
      local aug = vim.api.nvim_create_augroup("qs_colors", {})
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = aug,
        callback = set_colors,
      })
      set_colors() -- on startup the autocmd is missed as colorscheme is already loaded
    end,
    keys = {
      { "<leader>uq", "<cmd>QuickScopeToggle<cr>", desc = "Toggle QS Highlights" },
    },
  },
}
