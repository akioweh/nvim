---@type LazySpec
return {
  {
    "antosha417/nvim-lsp-file-operations",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neo-tree/neo-tree.nvim",
    },
    config = function()
      require("lsp-file-operations").setup()
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false,
    priority = 400,
    init = nil,
    opts = {
      window = {
        position = "left",
        width = 28,
        mappings = {
          ["j"] = function(state)
            local node = state.tree:get_node()
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end,
          ["d"] = "trash",
          ["u"] = "undo",
          ["U"] = "restore_from_trash",
          ["gx"] = {
            function(state)
              require("lazy.util").open(state.tree:get_node().path, { system = true })
            end,
            desc = "Open with System Application",
          },
        },
      },
      source_selector = {
        winbar = true,
        statusline = true,
      },
      filesystem = {
        hijack_netrw_behavior = "open_current",
      },
    },
  },
}
