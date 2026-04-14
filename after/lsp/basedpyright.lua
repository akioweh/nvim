---@type vim.lsp.Config
return {
  settings = {
    basedpyright = {
      analysis = {
        inlayHints = {
          genericTypes = true,
        },
      },
    },
  },
}
