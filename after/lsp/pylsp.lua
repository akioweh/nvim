---@type vim.lsp.Config
return {
  settings = {
    pylsp = {
      rope = {
        ropeFolder = { ".ropeproject" },
      },
      plugins = {
        autopep8 = { enabled = false },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        yapf = { enabled = false },
        ruff = { enabled = true, config = "~/.config/ruff/ruff.toml", formatEnabled = true },
        rope_autoimport = { enabled = true, completions = { enabled = false } },
        rope_rename = { enabled = false }, -- breaks autocomplete when enabled?
        jedi_rename = { enabled = false },
        rope_completion = { enabled = false, eager = false },
        jedi_completion = { enabled = true, fuzzy = false, eager = false },
        pylsp_mypy = { enabled = true },
        pylsp_rope = { rename = true },
        isort = { enabled = true },
      },
      signature = { formatter = "ruff" },
    },
  },
}
