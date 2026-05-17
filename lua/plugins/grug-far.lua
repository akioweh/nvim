---@type LazySpec
return {
  {
    "MagicDuck/grug-far.nvim",
    dir = "/home/akioweh/projects/nvim-plugins/grug-far.nvim",
    optional = true,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "grug-far",
        callback = function(args)
          local buf = args.buf
          -- grug-far sets filetype before bindInputSaavyKeys, so defer
          -- until after its setup completes on this tick.
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(buf) then
              return
            end

            local function steal(mode, lhs)
              for _, m in ipairs(vim.api.nvim_buf_get_keymap(buf, mode)) do
                if m.lhs == lhs and m.callback then
                  return m.callback
                end
              end
            end

            local cb_n_o = steal("n", "o")
            local cb_n_p = steal("n", "p")
            local cb_n_P = steal("n", "P")
            local cb_v_p = steal("v", "p")
            local cb_v_P = steal("v", "P")

            -- remove grug-far's overrides on the base keys so user globals win.
            for _, lhs in ipairs({ "o", "p", "P" }) do
              pcall(vim.api.nvim_buf_del_keymap, buf, "n", lhs)
            end
            for _, lhs in ipairs({ "p", "P" }) do
              pcall(vim.api.nvim_buf_del_keymap, buf, "v", lhs)
            end

            local function bind(mode, lhs, cb)
              if cb then
                vim.keymap.set(mode, lhs, cb, {
                  buffer = buf,
                  nowait = true,
                  noremap = true,
                  desc = "grug-far smart " .. lhs,
                })
              end
            end
            bind("n", "i", cb_n_o) -- smart open-below
            bind("n", "t", cb_n_p) -- smart paste-after
            bind("n", "T", cb_n_P) -- smart paste-before
            bind("x", "t", cb_v_p)
            bind("x", "T", cb_v_P)
          end)
        end,
      })
    end,
  },
}
