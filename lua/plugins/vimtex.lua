---@type LazySpec
return {
  {
    "lervag/vimtex",
    config = function()
      if vim.fn.has("win32") == 1 then
        vim.g.vimtex_view_general_viewer = "SumatraPDF"
        vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
      else
      end

      vim.g.vimtex_compiler_latexmk = {
        aux_dir = "../auxil", -- 'aux' is a reserved device name on Windows
        out_dir = "../out",
        -- executable = "latexmk",
        -- options = {
        --   "-pdf",
        --   "-interaction=nonstopmode",
        --   "-synctex=1",
        --   "-shell-escape",
        -- },
      }
      vim.g.vimtex_indent_ignored_envs = { "luacode", "luacode*" }
      vim.g.vimtex_fold_enabled = true
      vim.g.vimtex_fold_types = {
        comments = { enabled = true },
      }
    end,
  },
}
