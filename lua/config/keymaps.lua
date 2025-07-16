-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Snacks = require("snacks")

local map = vim.keymap.set
local unmap = vim.keymap.del
local function delmap(modes, key)
  map(modes, key, "<Nop>", { noremap = true, desc = "which_key_ignore" })
end

-- undo some LazyVim mappings
unmap("n", "<S-h>")
unmap("n", "<S-l>")
unmap({ "n", "v", "i" }, "<A-j>")

-- remap movement to j;kl
map({ "n", "x" }, ";", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map("", "j", "h", { noremap = true, desc = "Left" })
delmap("", "h")

map("", "zj", "zh", { noremap = true, desc = "Scroll Left" })
map("", "zl", "zl", { noremap = true, desc = "Scroll Right" })
map("", "zJ", "zH", { noremap = true, desc = "Scroll Half screen Left" })
map("", "zL", "zL", { noremap = true, desc = "Scroll Half screen Right" })
map("", "zh", "<nop>", { desc = "which_key_ignore" })
map("", "z;", "zj", { noremap = true, desc = "Next Fold (start of)" })
map("", "zk", "zk", { noremap = true, desc = "Previous Fold (end of)" })

map("", "<C-w>j", "<C-w>h", { desc = "Window left", noremap = true })
map("", "<C-w>k", "<C-w>k", { desc = "Window up", noremap = true })
map("", "<C-w>l", "<C-w>l", { desc = "Window right", noremap = true })
map("", "<C-w>;", "<C-w>j", { desc = "Window down", noremap = true })
map("", "<C-w>h", "<nop>", { desc = "which_key_ignore" })
map("", "<leader>wj", "<C-w>h", { desc = "Window left", noremap = true })
map("", "<leader>wk", "<C-w>k", { desc = "Window up", noremap = true })
map("", "<leader>wl", "<C-w>l", { desc = "Window right", noremap = true })
map("", "<leader>w;", "<C-w>j", { desc = "Window down", noremap = true })
map("", "<leader>wh", "<nop>", { desc = "which_key_ignore" })
unmap("", "<leader>wh")
-- remove LazyVim Ctrl- window nav
unmap("n", "<C-h>")
unmap("n", "<C-j>")
unmap("n", "<C-k>")
unmap("n", "<C-l>")

map("", "gJ", "0", { noremap = true, desc = "Beginning of Line" })
map("", "gL", "$", { noremap = true, desc = "End of Line" })
map("", "J", "v:count == 0 ? 'g^' : 'k^'", { noremap = true, expr = true, silent = true })
map("", "L", "v:count == 0 ? 'g$' : 'j$'", { noremap = true, expr = true, silent = true })

map("", ".", "f", { noremap = true })
map("", "m", "F", { noremap = true })
map("", ">", "t", { noremap = true })
map("", "M", "T", { noremap = true })
map("", ",", ";", { noremap = true })
map("", "<", ",", { noremap = true })

map("", "f", "w", { noremap = true })
map("", "F", "W", { noremap = true })
map("", "r", "e", { noremap = true })
map("", "R", "E", { noremap = true })
map("", "w", "b", { noremap = true })
map("", "W", "B", { noremap = true })
map("", "s", "ge", { noremap = true })
map("", "S", "gE", { noremap = true })
delmap("", "ge")
delmap("", "gE")

map("", "ge", "%", { noremap = true, desc = "Go to matching delimiter" })

map("", "g.", "g,", { noremap = true, desc = "Next in changelist" })
map("", "gm", "g;", { noremap = true, desc = "Previous in changelist" })
delmap("", "g,")
delmap("", "g;")
map("n", "<Tab>", "<Tab>", { noremap = true, desc = "Next in changelist" })
map("n", "<S-Tab>", "<C-o>", { noremap = true, desc = "Previous in changelist" })

map("", "gi", "H", { noremap = true, desc = "Top (Nth) line in screen" })
map("", "gk", "M", { noremap = true, desc = "Middle line in screen" })
map("", "g,", "L", { noremap = true, desc = "Bottom (Nth) line in screen" })

map("", "<C-k>", "<C-u>", { noremap = true, desc = "Scroll page Up" })
map("", "<C-;>", "<C-d>", { noremap = true, desc = "Scroll page Down" })

map("", "a", "c", { noremap = true })
map("", "A", "C", { noremap = true })
map("", "t", "y", { noremap = true })
map("", "T", "Y", { noremap = true })
map({ "n", "o" }, "c", ">", { noremap = true })
map("v", "c", ">gv", { noremap = true })
map({ "n", "o" }, "C", "<", { noremap = true })
map("v", "C", "<gv", { noremap = true })
map("", "y", "p", { noremap = true })
map("", "Y", "P", { noremap = true })
map("", "p", "r", { noremap = true })
map("", "P", "R", { noremap = true })
map("", "gs", "s", { noremap = true })
map("", "gS", "S", { noremap = true })
map("", "b", "u", { noremap = true })
map("", "B", "U", { noremap = true })

map("", "o", "a", { noremap = true })
map("", "O", "A", { noremap = true })
map("", "u", "i", { noremap = true })
map("", "U", "I", { noremap = true })
map("n", "i", "o", { noremap = true })
map("n", "I", "O", { noremap = true })
map("v", "<Tab>", "o", { noremap = true })
map("v", "<S-Tab>", "O", { noremap = true })

map({ "n", "x" }, "<leader>j", "J", { noremap = true, desc = "Join Lines" })

map("", "<M-j>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map("", "<M-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("i", "<M-j>", "<C-o><cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map("i", "<M-l>", "<C-o><cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })

map("n", "gci", "gco", { desc = "Comment above" })
map("n", "gcI", "gcO", { desc = "Comment below" })

map("", "0", "m", { noremap = true })

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
Snacks.toggle({
  name = "Virtual Line Diagnostics",
  get = function()
    ---@diagnostic disable-next-line: return-type-mismatch
    return vim.diagnostic.config().virtual_lines
  end,
  set = function(state)
    vim.diagnostic.config({ virtual_lines = state })
    vim.diagnostic.config({ virtual_text = not state })
  end,
}):map("<leader>uv")
