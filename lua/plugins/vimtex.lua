return {
  {
    "lervag/vimtex",
    -- lazy = false, -- disable lazy-loading for proper inverse search support (fr?)
    config = function()
      --   vim.g.vimtex_view_general_viewer = "SumatraPDF"
      --   vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
      --
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
