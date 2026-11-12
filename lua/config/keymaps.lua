vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Add mapping only if lazy handler does not already exist
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? vim.keymap.set.Opts
local function add(mode, lhs, rhs, opts)
  for _, mapping_mode in ipairs(type(mode) == "table" and mode or { mode }) do
    if not require("lazy.core.handler").handlers.keys:have(lhs, mapping_mode) then
      vim.keymap.set(mapping_mode, lhs, rhs, opts)
    end
  end
end

---map to <Nop>. Useful for builtins that cannot be unmmapped
---@param mode string|string[]
---@param lhs string
local function clr(mode, lhs)
  add(mode, lhs, "<Nop>", { desc = "which_key_ignore" })
end

local m = { "n", "x", "o" } -- m for Motion
local n = { "n", "x" } -- n for Normal

-- remap movement to j;kl
add(m, ";", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
add(m, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
add(m, "j", "h", { desc = "Left" })
clr(m, "h") -- h is mapped to . later

add(n, "zj", "zh", { desc = "Scroll Left" })
add(n, "zl", "zl", { desc = "Scroll Right" })
add(n, "zJ", "zH", { desc = "Scroll Half screen Left" })
add(n, "zL", "zL", { desc = "Scroll Half screen Right" })
clr(n, "zh")
add(m, "z;", "zj", { desc = "Next Fold (start of)" })
add(m, "zk", "zk", { desc = "Prev Fold (end of)" })

---@type string[][]
local window_directions = {
  { "j", "h", "Window left" },
  { "k", "k", "Window up" },
  { "l", "l", "Window right" },
  { ";", "j", "Window down" },
  { "J", "H", "Fling Window Left" },
  { "K", "K", "Fling Window Up" },
  { "L", "L", "Fling Window Right" },
  { ":", "J", "Fling Window Down" },
}
for _, prefix in ipairs({ "<C-w>", "<leader>w" }) do
  for _, direction in ipairs(window_directions) do
    add(n, prefix .. direction[1], "<C-w>" .. direction[2], { desc = direction[3] })
  end
end
clr(n, "<C-w>h")
clr(n, "<C-w>H")
add(n, "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = not not vim.g.vscode, silent = true })
add(n, "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = not not vim.g.vscode, silent = true })
add(n, "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = not not vim.g.vscode, silent = true })

add(m, "gJ", "0", { desc = "Beginning of Line" })
add(m, "gL", "$", { desc = "End of Line" })
add(m, "J", "v:count == 0 ? 'g^' : 'k^'", { expr = true, silent = true })
add(m, "L", "v:count == 0 ? 'g$' : 'j$'", { expr = true, silent = true })

add(m, ".", "f")
add(m, "m", "F")
add(m, ">", "t")
add(m, "M", "T")
add(m, ",", ";")
add(m, "<", ",")

add(m, "f", "w")
add(m, "F", "W")
add(m, "r", "e")
add(m, "R", "E")
add(m, "w", "b")
add(m, "W", "B")
add(m, "s", "ge")
add(m, "S", "gE")
clr(m, "gE")

add(m, "ge", "%", { desc = "Matching Delimiter" })
add(n, "h", ".")

-- both changelist and jumplist jump commands are not motions
add(n, "g.", "g,", { desc = "Next Change" })
add(n, "gm", "g;", { desc = "Prev Change" })
clr(n, "g,")
clr(n, "g;")
-- jumplist navigation
add("n", "<Tab>", "<C-i>", { desc = "Next Jump" })
add("n", "<S-Tab>", "<C-o>", { desc = "Prev Jump" })

add(m, "gi", "H", { desc = "Top (Nth) Line" })
add(m, "gk", "M", { desc = "Middle Line" })
add(m, "g,", "L", { desc = "Bottom (Nth) Line" })
clr(m, "H")

add(n, "<C-k>", "<C-u>", { desc = "Scroll Up" })
add(n, "<C-;>", "<C-d>", { desc = "Scroll Down" })

add(n, "A", "C")
add(n, "t", "p")
add(n, "T", "P")
add({ "n", "o" }, "c", ">")
add("x", "c", ">gv")
add({ "n", "o" }, "C", "<")
add("x", "C", "<gv")
add(n, "p", "r")
add(n, "P", "R")
-- map(nxo, "gs", "s")
-- map(nxo, "gS", "S")
add(n, "b", "u")
add(n, "B", "U")

add(n, "O", "A")
add(n, "u", "i")
add(n, "U", "I")
add("n", "i", "o")
add("n", "I", "O")
add("x", "<Tab>", "o") -- toggle selection cursor edge
add("x", "<S-Tab>", "O") -- above but on same line in block visual mode

add(n, "<leader>j", "J", { desc = "Join Lines" })
add("n", "0", "m")

add(m, "a", "c", { nowait = true })
add("n", "o", "a")

local textobjects = { '"', "'", "(", ")", "<", ">", "B", "W", "[", "]", "`", "b", "p", "s", "t", "w", "{", "}" }
for _, obj in ipairs(textobjects) do
  local a_key = "a" .. obj
  local o_key = "o" .. obj
  add({ "x", "o" }, o_key, a_key)
end

add("n", "gci", "o<Esc>c_.<esc><cmd>normal gcc<cr>A<bs>", { silent = true, desc = "Comment Above" })
add("n", "gcI", "O<Esc>c_.<esc><cmd>normal gcc<cr>A<bs>", { silent = true, desc = "Comment Below" })

-- move current line up/down
add("n", "<A-;>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down", silent = true })
add("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up", silent = true })
add("i", "<A-;>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down", silent = true })
add("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up", silent = true })
add("x", "<A-;>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down", silent = true })
add("x", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up", silent = true })

-- tabs
add("n", "<leader><tab>L", "<cmd>tablast<cr>", { desc = "Last Tab" })
add("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
add("n", "<leader><tab>J", "<cmd>tabfirst<cr>", { desc = "First Tab" })
add("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
add("n", "<leader><tab>l", "<cmd>tabnext<cr>", { desc = "Next Tab" })
add("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
add("n", "<leader><tab>j", "<cmd>tabprevious<cr>", { desc = "Prev Tab" })

-- window resizing
add("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height", silent = true })
add("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height", silent = true })
add("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width", silent = true })
add("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width", silent = true })

-- buffers
add("n", "[b", "<cmd>execute 'bprevious' . v:count1<cr>", { desc = "Prev Buffer", silent = true })
add("n", "]b", "<cmd>execute 'bnext' . v:count1<cr>", { desc = "Next Buffer", silent = true })
add("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer", silent = true })
add("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer", silent = true })
add("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window", silent = true })

-- search
add("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", {
  desc = "Redraw / Clear hlsearch / Diff Update",
  silent = true,
})
add("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result", silent = true })
add({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result", silent = true })
add("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result", silent = true })
add({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result", silent = true })

--- undo breakpoints
add("i", ",", ",<c-g>u", { silent = true })
add("i", ".", ".<c-g>u", { silent = true })
add("i", ";", ";<c-g>u", { silent = true })

add("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg", silent = true })

-- lists
add("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List", silent = true })
add("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List", silent = true })
add("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix", silent = true })
add("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix", silent = true })

-- diagnostics
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
add("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics", silent = true })
add("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic", silent = true })
add("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic", silent = true })
add("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error", silent = true })
add("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error", silent = true })
add("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning", silent = true })
add("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning", silent = true })

-- misc
add("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Normal Mode", silent = true })
add({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File", silent = true })
add({ "i", "c" }, "<C-BS>", "<C-w>", { desc = "Delete Word", silent = true }) -- only for gui (no control code)
add("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All", silent = true })
add("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos", silent = true })
add("n", "<leader>uI", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input("I")
end, { desc = "Inspect Tree", silent = true })
add("n", "<leader>fn", function()
  local cur_dir = vim.fn.expand("%:p:h")
  local new_name = vim.fn.input("New file: ", "", "file")
  if new_name ~= "" then
    local new_path = cur_dir .. "/" .. new_name
    vim.cmd("edit " .. new_path)
  end
end, { silent = true, desc = "New File (here)" })
