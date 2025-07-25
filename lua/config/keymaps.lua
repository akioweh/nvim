-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Snacks = require("snacks")

local map = vim.keymap.set
local unmap = vim.keymap.del
local function delmap(modes, key)
  map(modes, key, "<Nop>", { noremap = true, desc = "which_key_ignore" })
end

local nxo = { "n", "x", "o" }

-- undo some LazyVim mappings
unmap("n", "<S-h>")
unmap("n", "<S-l>")
unmap({ "n", "v", "i" }, "<A-j>")

-- remap movement to j;kl
map({ "n", "x" }, ";", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map(nxo, "j", "h", { noremap = true, desc = "Left" })
delmap(nxo, "h")

map(nxo, "zj", "zh", { noremap = true, desc = "Scroll Left" })
map(nxo, "zl", "zl", { noremap = true, desc = "Scroll Right" })
map(nxo, "zJ", "zH", { noremap = true, desc = "Scroll Half screen Left" })
map(nxo, "zL", "zL", { noremap = true, desc = "Scroll Half screen Right" })
map(nxo, "zh", "<nop>", { desc = "which_key_ignore" })
map(nxo, "z;", "zj", { noremap = true, desc = "Next Fold (start of)" })
map(nxo, "zk", "zk", { noremap = true, desc = "Previous Fold (end of)" })

map(nxo, "<C-w>j", "<C-w>h", { desc = "Window left", noremap = true })
map(nxo, "<C-w>k", "<C-w>k", { desc = "Window up", noremap = true })
map(nxo, "<C-w>l", "<C-w>l", { desc = "Window right", noremap = true })
map(nxo, "<C-w>;", "<C-w>j", { desc = "Window down", noremap = true })
map(nxo, "<C-w>h", "<nop>", { desc = "which_key_ignore" })
map(nxo, "<leader>wj", "<C-w>h", { desc = "Window left", noremap = true })
map(nxo, "<leader>wk", "<C-w>k", { desc = "Window up", noremap = true })
map(nxo, "<leader>wl", "<C-w>l", { desc = "Window right", noremap = true })
map(nxo, "<leader>w;", "<C-w>j", { desc = "Window down", noremap = true })
map(nxo, "<leader>wh", "<nop>", { desc = "which_key_ignore" })
unmap({ "n", "x" }, "<leader>wh")
-- remove LazyVim Ctrl- window nav
unmap("n", "<C-h>")
unmap("n", "<C-j>")
unmap("n", "<C-k>")
unmap("n", "<C-l>")

map(nxo, "gJ", "0", { noremap = true, desc = "Beginning of Line" })
map(nxo, "gL", "$", { noremap = true, desc = "End of Line" })
map(nxo, "J", "v:count == 0 ? 'g^' : 'k^'", { noremap = true, expr = true, silent = true })
map(nxo, "L", "v:count == 0 ? 'g$' : 'j$'", { noremap = true, expr = true, silent = true })

map(nxo, ".", "f", { noremap = true })
map(nxo, "m", "F", { noremap = true })
map(nxo, ">", "t", { noremap = true })
map(nxo, "M", "T", { noremap = true })
map(nxo, ",", ";", { noremap = true })
map(nxo, "<", ",", { noremap = true })

map(nxo, "f", "w", { noremap = true })
map(nxo, "F", "W", { noremap = true })
map(nxo, "r", "e", { noremap = true })
map(nxo, "R", "E", { noremap = true })
map(nxo, "w", "b", { noremap = true })
map(nxo, "W", "B", { noremap = true })
map(nxo, "s", "ge", { noremap = true })
map(nxo, "S", "gE", { noremap = true })
delmap(nxo, "ge")
delmap(nxo, "gE")

map(nxo, "ge", "%", { noremap = true, desc = "Go to matching delimiter" })

map(nxo, "g.", "g,", { noremap = true, desc = "Next in changelist" })
map(nxo, "gm", "g;", { noremap = true, desc = "Previous in changelist" })
delmap(nxo, "g,")
delmap(nxo, "g;")
map("n", "<Tab>", "<Tab>", { noremap = true, desc = "Next in changelist" })
map("n", "<S-Tab>", "<C-o>", { noremap = true, desc = "Previous in changelist" })

map(nxo, "gi", "H", { noremap = true, desc = "Top (Nth) line in screen" })
map(nxo, "gk", "M", { noremap = true, desc = "Middle line in screen" })
map(nxo, "g,", "L", { noremap = true, desc = "Bottom (Nth) line in screen" })

map(nxo, "<C-k>", "<C-u>", { noremap = true, desc = "Scroll page Up" })
map(nxo, "<C-;>", "<C-d>", { noremap = true, desc = "Scroll page Down" })

map(nxo, "a", "c", { noremap = true })
map(nxo, "A", "C", { noremap = true })
map(nxo, "t", "y", { noremap = true })
map(nxo, "T", "Y", { noremap = true })
map({ "n", "o" }, "c", ">", { noremap = true })
map("x", "c", ">gv", { noremap = true })
map({ "n", "o" }, "C", "<", { noremap = true })
map("x", "C", "<gv", { noremap = true })
map(nxo, "y", "p", { noremap = true })
map(nxo, "Y", "P", { noremap = true })
map(nxo, "p", "r", { noremap = true })
map(nxo, "P", "R", { noremap = true })
map(nxo, "gs", "s", { noremap = true })
map(nxo, "gS", "S", { noremap = true })
map(nxo, "b", "u", { noremap = true })
map(nxo, "B", "U", { noremap = true })

map(nxo, "o", "a", { noremap = true })
map(nxo, "O", "A", { noremap = true })
map(nxo, "u", "i", { noremap = true })
map(nxo, "U", "I", { noremap = true })
map("n", "i", "o", { noremap = true })
map("n", "I", "O", { noremap = true })
map("v", "<Tab>", "o", { noremap = true })
map("v", "<S-Tab>", "O", { noremap = true })

-- fighting the builtin o mode maps starting with "a"
map("o", "a", "_", { noremap = true, nowait = true, silent = true, desc = "which_key_ignore" })

map({ "n", "x" }, "<leader>j", "J", { noremap = true, desc = "Join Lines" })

map(nxo, "<M-j>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map(nxo, "<M-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("i", "<M-j>", "<C-o><cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map("i", "<M-l>", "<C-o><cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })

map("n", "gci", "gco", { desc = "Comment above" })
map("n", "gcI", "gcO", { desc = "Comment below" })

map("n", "0", "m", { noremap = true })

map("n", "<A-;>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down", silent = true })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up", silent = true })
map("i", "<A-;>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down", silent = true })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up", silent = true })
map("v", "<A-;>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down", silent = true })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up", silent = true })
map({ "n", "v", "i" }, "<A-D>", "<A-;>")
map({ "i", "c" }, "<C-BS>", "<C-w>", { desc = "Delete Word", noremap = true, silent = true })

unmap("n", "<leader><tab>l")
unmap("n", "<leader><tab>f")
unmap("n", "<leader><tab>]")
unmap("n", "<leader><tab>[")
map("n", "<leader><tab>L", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>J", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>l", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>j", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- idk what's the source that sets the <leader>fn keymap
unmap("n", "<leader>fn")
map("n", "<leader>fn", function()
  local cur_dir = vim.fn.expand("%:p:h")
  local new_name = vim.fn.input("New file: ", "", "file")
  if new_name ~= "" then
    local new_path = cur_dir .. "/" .. new_name
    vim.cmd("edit " .. new_path)
  end
end, { noremap = true, silent = true, desc = "New File (here)" })
map("n", "<leader>fN", function()
  local root_dir = require("lazyvim.util").root()
  local new_name = vim.fn.input("New file: ", "", "file")
  if new_name ~= "" then
    local new_path = root_dir .. "/" .. new_name
    vim.cmd("edit " .. new_path)
  end
end, { noremap = true, silent = true, desc = "New File (root dir)" })

-- w diagnostics
local cached_virtual_lines = nil
local cached_virtual_text = nil

Snacks.toggle({
  name = "Virtual Line Diagnostics",
  get = function()
    local config = vim.diagnostic.config() or {}
    return config.virtual_lines ~= false
  end,
  set = function(state)
    local config = vim.diagnostic.config() or {}

    if state then
      local cur_virtual_text = config.virtual_text
      if cur_virtual_text ~= nil and cur_virtual_text ~= false then
        if type(cur_virtual_text) == "function" then
          cached_virtual_text = cur_virtual_text
        else
          cached_virtual_text = function(_, _)
            return cur_virtual_text
          end
        end
      end
      config.virtual_lines = cached_virtual_lines or true
      config.virtual_text = false
    else
      local cur_virtual_lines = config.virtual_lines
      if cur_virtual_lines ~= nil and cur_virtual_lines ~= false then
        if type(cur_virtual_lines) == "function" then
          cached_virtual_lines = cur_virtual_lines
        else
          cached_virtual_lines = function(_, _)
            return cur_virtual_lines
          end
        end
      end
      config.virtual_text = cached_virtual_text or true
      config.virtual_lines = false
    end

    vim.diagnostic.config(config)
  end,
}):map("<leader>uv")
