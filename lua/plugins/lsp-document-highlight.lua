---@type LazySpec
return {
  {
    "akioweh/lsp-document-highlight.nvim",
    lazy = false,
    keys = {
      {
        "[[",
        function()
          require("lsp-document-highlight").jump(-vim.v.count1)
        end,
        desc = "Previous Reference",
      },
      {
        "]]",
        function()
          require("lsp-document-highlight").jump(vim.v.count1)
        end,
        desc = "Next Reference",
      },
    },
    ---@type LDH.config
    opts = {
      throttle = 50,
    },
  },
}
