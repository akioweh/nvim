---@type LazySpec
return {
  {
    "gbprod/yanky.nvim",
    keys = function()
      return {
        {
          "<leader>y",
          function()
            if LazyVim.pick.picker.name == "telescope" then
              require("telescope").extensions.yank_history.yank_history({})
            elseif LazyVim.pick.picker.name == "snacks" then
              Snacks.picker.yanky()
            else
              vim.cmd([[YankyRingHistory]])
            end
          end,
          mode = { "n", "x" },
          desc = "Open Yank History",
        },
        { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
        { "t", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Text After Cursor" },
        { "T", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Cursor" },
        { "gt", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Text After Selection" },
        { "gT", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Selection" },
        { "[t", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
        { "]t", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
        { "]t", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
        { "[T", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
        { "]t", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
        { "[T", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
        { ">t", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
        { "<t", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
        { ">T", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
        { "<T", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
        { "=t", "<Plug>(YankyPutAfterFilter)", desc = "Put After Applying a Filter" },
        { "=T", "<Plug>(YankyPutBeforeFilter)", desc = "Put Before Applying a Filter" },
      }
    end,
  },
}
