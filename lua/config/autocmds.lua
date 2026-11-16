local cac = vim.api.nvim_create_autocmd

-- this works nicely, but is so verbose...
cac("BufWritePre", {
  desc = "Apply Ruff fixes synchronously on save",
  pattern = "*.py",
  callback = function(args)
    if not LazyVim.format.enabled(args.buf) then
      return
    end

    local client = vim.lsp.get_clients({ bufnr = args.buf, name = "ruff" })[1]
    if not client then
      return
    end

    -- no util function exits to make params for arbitrary bufnr :(
    local params = {
      textDocument = vim.lsp.util.make_text_document_params(args.buf),
      range = {
        start = { line = 0, character = 0 },
        ["end"] = { line = vim.api.nvim_buf_line_count(args.buf), character = 0 },
      },
      context = { only = { "source.fixAll.ruff" }, diagnostics = {} },
    }

    local result = client:request_sync("textDocument/codeAction", params, nil, args.buf)
    if not result then
      return
    end

    -- no ready-to-use handler exits for a single code action :(
    for _, action in pairs(result.result) do
      if not action.edit and not action.command then
        local resolved = client:request_sync("codeAction/resolve", action, nil, args.buf)
        if resolved and resolved.result then
          action = resolved.result
        end
      end

      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
      elseif action.command then
        local command_params = {
          command = action.command.command,
          arguments = action.command.arguments,
        }
        client:request_sync("workspace/executeCommand", command_params, nil, args.buf)
      end
    end
  end,
})
