---@type vim.lsp.Config
return {
  on_attach = function(client)
    -- we use panache for this
    client.server_capabilities.documentSymbolProvider = false
  end,
}
