-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local unmap = vim.keymap.del

unmap("n", "<S-h>")
unmap("n", "<S-l>")
unmap({ "n", "v", "i" }, "<A-j>")
map({ "n", "x" }, ";", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

vim.cmd([[
no j h

no zj zh
no zJ zH

no <C-w>j <C-w>h
no <C-w>; <C-w>j
no <C-w>J <C-w>H
no <C-w>: <C-w>J
no <space>wj <C-w>h
no <space>w; <C-w>j
no <space>wJ <C-w>H
no <space>w: <C-w>J

no gJ 0
no gL $
no J ^
no L g_
no \ |
no . f
no m F
no > t
no M T
no , ;
no < ,


no f w
no F W
no r e
no R E
no w b
no W B
no s ge
no S gE


no 0 m


no ge %

no g. g,
no gm g;
no <S-Tab> <C-o>


no gj H
no gk M
no gl L


no <C-;> <C-d>
no <C-k> <C-u>


no a c
no t y
no c >
no C <

no A C
no T Y


no <leader>j J
no h K
no y p
no Y P
no p r
no gs s
no gS S
no b u
no B U


no o a
no O A
no u i
no U I
nn i o
nn I O
vn <Tab> o
vn <S-Tab> O

no P R


map <M-j> [b
map <M-l> ]b
inoremap <M-j> <C-O>:bprevious<CR>
inoremap <M-l> <C-O>:bnext<CR>

nn gci gco
nn gcI gcO
]])

map("n", "<A-;>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down", silent = true })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up", silent = true })
map("i", "<A-;>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down", silent = true })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up", silent = true })
map("v", "<A-;>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down", silent = true })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up", silent = true })
map({ "n", "v", "i" }, "<A-D>", "<A-;>")
map({ "i", "c" }, "<C-BS>", "<C-w>", { desc = "Delete previous word", noremap = true, silent = true })
