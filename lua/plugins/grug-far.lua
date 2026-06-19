-- local function extraction via func-introspection
local function get_upvalue_by_name(func, target_name)
  local idx = 1
  while true do
    local name, value = debug.getupvalue(func, idx)
    if not name then
      break
    end
    if name == target_name then
      return value, idx
    end
    idx = idx + 1
  end
  error(string.format("Upvalue '%s' not found in function '%s'", target_name, tostring(func)))
end

---@type LazySpec
return {
  {
    "MagicDuck/grug-far.nvim",
    dev = true,
    optional = true,
    config = function(_, opts)
      require("grug-far").setup(opts)

      -- monkeypatching of grug-far.inputs.bindInputSaavyKeys to replace the p/P/o with our t/T/i keys
      local inputs = require("grug-far.inputs")
      local extractMapping = get_upvalue_by_name(inputs.bindInputSaavyKeys, "extractMapping")
      local pasteBelow = get_upvalue_by_name(inputs.bindInputSaavyKeys, "pasteBelow")
      local pasteAbove = get_upvalue_by_name(inputs.bindInputSaavyKeys, "pasteAbove")
      local openBelow = get_upvalue_by_name(inputs.bindInputSaavyKeys, "openBelow")
      local setupInputBoundaryBackspace = get_upvalue_by_name(inputs.bindInputSaavyKeys, "setupInputBoundaryBackspace")
      inputs.bindInputSaavyKeys = function(context, buf)
        -- capture any user mappings for these keys before we override them,
        -- so our behavior can fall through to them instead of clobbering them
        local pasteFallbacks = {
          n = { p = extractMapping(buf, "n", "t"), P = extractMapping(buf, "n", "T") },
          v = { p = extractMapping(buf, "v", "t"), P = extractMapping(buf, "v", "T") },
        }
        local openFallback = extractMapping(buf, "n", "i")

        vim.api.nvim_buf_set_keymap(buf, "n", "t", "", {
          noremap = true,
          nowait = true,
          callback = function()
            pasteBelow(context, buf, false, pasteFallbacks.n)
          end,
        })
        vim.api.nvim_buf_set_keymap(buf, "v", "t", "", {
          noremap = true,
          nowait = true,
          callback = function()
            pasteBelow(context, buf, true, pasteFallbacks.v)
          end,
        })
        vim.api.nvim_buf_set_keymap(buf, "n", "T", "", {
          noremap = true,
          nowait = true,
          callback = function()
            pasteAbove(context, buf, false, pasteFallbacks.n)
          end,
        })
        vim.api.nvim_buf_set_keymap(buf, "v", "T", "", {
          noremap = true,
          nowait = true,
          callback = function()
            pasteAbove(context, buf, true, pasteFallbacks.v)
          end,
        })
        vim.api.nvim_buf_set_keymap(buf, "n", "i", "", {
          noremap = true,
          nowait = true,
          callback = function()
            openBelow(context, buf, openFallback)
          end,
        })

        if context.options.backspaceEol then
          local isSetUp = false
          vim.api.nvim_create_autocmd({ "InsertEnter" }, {
            group = context.augroup,
            buffer = buf,
            callback = function()
              if isSetUp then
                return
              end

              setupInputBoundaryBackspace(buf, context)
              isSetUp = true
            end,
          })
        end
      end
    end,
  },
}
