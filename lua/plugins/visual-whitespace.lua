return {
  {
    "mcauley-penney/visual-whitespace.nvim",
    event = "ModeChanged *:[vV\22]",
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
          vim.api.nvim_set_hl(0, "VisualNonText", {
            fg = "#101010",
            bg = visual_hl.bg,
          })
        end,
      })

      local state = true
      require("snacks")
        .toggle({
          name = "Visual Whitespace",
          get = function()
            return state
          end,
          set = function(new_state)
            if new_state ~= state then
              require("visual-whitespace").toggle()
              state = not state
            end
          end,
        })
        :map("<leader>uW", { mode = { "n", "x" } })
    end,
  },
}
