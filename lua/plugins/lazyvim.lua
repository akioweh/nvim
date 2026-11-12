---@type LazySpec
return {
  {
    "akioweh/LazyVim",
    name = "LazyVim",
    optional = true,
    opts = {
      defaults = { keymaps = false },
    },
    keys = {
      {
        "<esc>",
        function()
          vim.cmd("noh")
          LazyVim.cmp.actions.snippet_stop()
          return "<esc>"
        end,
        mode = { "i", "n", "s" },
        expr = true,
        desc = "Escape and Clear hlsearch",
        silent = true,
      },
      {
        "<leader>cf",
        function()
          LazyVim.format({ force = true })
        end,
        mode = { "n", "x" },
        desc = "Format",
        silent = true,
      },
      {
        "<leader>fN",
        function()
          local root_dir = require("lazyvim.util").root()
          local new_name = vim.fn.input("New file: ", "", "file")
          if new_name ~= "" then
            local new_path = root_dir .. "/" .. new_name
            vim.cmd("edit " .. new_path)
          end
        end,
        silent = true,
        desc = "New File (root dir)",
      },
    },
  },
}
