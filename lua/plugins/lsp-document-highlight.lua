---@type LazySpec
return {
  {
    "akioweh/lsp-document-highlight.nvim",
    lazy = false,
    keys = {
      {
        "#",
        function()
          if not require("lsp-document-highlight").jump(-vim.v.count1) then
            -- using raw feedkeys to avoid stacktrace being printed when Vim: E348 is thrown (when cursor on whitespace)
            vim.api.nvim_feedkeys(vim.v.count1 .. "#", "n", false)
          end
        end,
        desc = "Previous Reference / #",
      },
      {
        "*",
        function()
          if not require("lsp-document-highlight").jump(vim.v.count1) then
            vim.api.nvim_feedkeys(vim.v.count1 .. "*", "n", false)
          end
        end,
        desc = "Next Reference / *",
      },
    },
    ---@type LDH.config
    opts = {
      throttle = 50,
      clamp_jumps = true,
    },
  },
}
