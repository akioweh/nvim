local cac = vim.api.nvim_create_autocmd

cac("FileType", {
  pattern = "tex",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.breakindent = true
    vim.opt_local.breakindentopt = "shift:2,sbr"
  end,
})

cac("FileType", {
  pattern = { "cpp", "c", "cxx", "h", "hpp" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.breakindentopt = "shift:2,sbr"
  end,
})

cac("FileType", {
  group = vim.api.nvim_create_augroup("FzfLuaEsc", { clear = true }),
  pattern = "fzf",
  callback = function(e)
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n><C-w>c", { buffer = e.buf, silent = true, nowait = true })
  end,
})

-- this works nicely, but is so verbose...
cac("BufWritePre", {
  desc = "Run Ruff organize imports synchronous on save",
  pattern = "*.py",
  callback = function(args)
    if not vim.g.autoformat or vim.b[args.buf].autoformat == false then
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
      context = { only = { "source.organizeImports" }, diagnostics = {} },
    }

    local result = client:request_sync("textDocument/codeAction", params, 1000, args.buf)
    if not result then
      return
    end

    -- no ready-to-use handler exits for a single code action :(
    for _, action in pairs(result.result) do
      if not action.edit and not action.command then
        local resolved = client:request_sync("codeAction/resolve", action, 1000, args.buf)
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
        client:request_sync("workspace/executeCommand", command_params, 1000, args.buf)
      end
    end
  end,
})
