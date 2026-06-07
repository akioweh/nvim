---@type vim.lsp.Config
return {
  -- if panache fails to find root (e.g. when editing isolated files),
  -- it also won't load any configs (even the user-global one), so
  -- we fake a root to for single-file editing to load the config at ~/.config/panache/config.toml
  root_dir = function(bufnr, on_dir)
    local markers = { ".panache.toml", "panache.toml", "_quarto.yml", "_bookdown.yml", ".git" }
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if fname == "" then
      return on_dir(vim.fn.getcwd())
    end
    local found = vim.fs.find(markers, { path = vim.fs.dirname(fname), upward = true })[1]
    on_dir(found and vim.fs.dirname(found) or vim.fs.dirname(fname))
  end,
}
