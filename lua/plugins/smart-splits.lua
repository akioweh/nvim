---@type LazySpec
return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false, -- self-lazy
    keys = {
      {
        "<C-Up>",
        function()
          require("smart-splits").resize_up()
        end,
        desc = "Resize Window Up",
      },
      {
        "<C-Down>",
        function()
          require("smart-splits").resize_down()
        end,
        desc = "Resize Window Down",
      },
      {
        "<C-Left>",
        function()
          require("smart-splits").resize_left()
        end,
        desc = "Resize Window Left",
      },
      {
        "<C-Right>",
        function()
          require("smart-splits").resize_right()
        end,
        desc = "Resize Window Right",
      },
      {
        "<leader>wj",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Move to Left Window",
      },
      {
        "<leader>wk",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Move to Upper Window",
      },
      {
        "<leader>wl",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Move to Right Window",
      },
      {
        "<leader>w;",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Move to Lower Window",
      },
    },
    opts = {},
  },
}
