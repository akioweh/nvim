local add = vim.keymap.set
local rmv = vim.keymap.del
---map to <Nop>. Useful for builtins that cannot be unmmapped
---@param mode string|string[]
---@param lhs string
local function clr(mode, lhs)
  add(mode, lhs, "<Nop>", { desc = "which_key_ignore" })
end

local LAZY = true -- whether to remove certain mappings added by LazyVim

local m = { "n", "x", "o" } -- m for Motion
local n = { "n", "x" } -- n for Normal

if LAZY then -- buffer switching using H and L
  rmv("n", "<S-h>")
  rmv("n", "<S-l>")
end

-- remap movement to j;kl
add(m, ";", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
add(m, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
add(m, "j", "h", { desc = "Left" })
clr(m, "h")
if LAZY then -- no need for "smart" up/down on the arrow keys
  rmv({ "n", "x" }, "<Down>")
  rmv({ "n", "x" }, "<Up>")
end

add(n, "zj", "zh", { desc = "Scroll Left" })
add(n, "zl", "zl", { desc = "Scroll Right" })
add(n, "zJ", "zH", { desc = "Scroll Half screen Left" })
add(n, "zL", "zL", { desc = "Scroll Half screen Right" })
clr(n, "zh")
add(m, "z;", "zj", { desc = "Next Fold (start of)" })
add(m, "zk", "zk", { desc = "Prev Fold (end of)" })

add(n, "<C-w>j", "<C-w>h", { desc = "Window left" })
add(n, "<C-w>k", "<C-w>k", { desc = "Window up" })
add(n, "<C-w>l", "<C-w>l", { desc = "Window right" })
add(n, "<C-w>;", "<C-w>j", { desc = "Window down" })
clr(n, "<C-w>h")
-- modless window movement
add(n, "<leader>wj", "<C-w>h", { desc = "Window left" })
add(n, "<leader>wk", "<C-w>k", { desc = "Window up" })
add(n, "<leader>wl", "<C-w>l", { desc = "Window right" })
add(n, "<leader>w;", "<C-w>j", { desc = "Window down" })
if LAZY then
  rmv("n", "<C-h>")
  rmv("n", "<C-j>")
  rmv("n", "<C-k>")
  rmv("n", "<C-l>")
end

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
add(m, "t", "y")
add(n, "T", "Y")
add({ "n", "o" }, "c", ">")
add("x", "c", ">gv")
add({ "n", "o" }, "C", "<")
add("x", "C", "<gv")
add("n", "y", "p")
add("x", "y", '"_dP') -- "replace"/"paste in-place" behavior
add(n, "Y", "P")
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
add("v", "<Tab>", "o") -- toggle selection cursor edge
add("v", "<S-Tab>", "O") -- above but on same line in block visual mode

add(n, "<leader>j", "J", { desc = "Join Lines" })
add("n", "0", "m")

-- a more hacky but robust mapping of o -> a and a -> c on the keypress level*
-- *: could still face timeoutlen delay due to existing prefix mappings :(
if LAZY then -- no clue where these come from
  rmv({ "x", "o" }, "a")
end
add(m, "<Plug>(KpnC)", "c") -- another hack as nvim_feedkeys's "no remap" option doesn't work the same
add(m, "<Plug>(KpA)", "a", { remap = true })
local ns = vim.api.nvim_create_namespace("mapper")
local kpC = vim.api.nvim_replace_termcodes("<Plug>(KpnC)", true, false, true)
local kpA = vim.api.nvim_replace_termcodes("<Plug>(KpA)", true, false, true)
vim.on_key(function(mapped, raw)
  local mode_info = vim.api.nvim_get_mode()
  local mode = mode_info.mode
  if raw == kpC or raw == kpA then
    return
  end
  local n_ = mode:match("^n")
  local v_ = mode:match("^v")
  local V_ = mode:match("^V")
  local Vc = mode:match("^CTRL-V")
  if n_ or v_ or V_ or Vc then
    if mapped:match("[fFtT]") then
      return
    end
    if raw == "a" then
      vim.api.nvim_feedkeys(kpC, "L", false)
      return ""
    end
    if raw == "o" then
      vim.api.nvim_feedkeys(kpA, "L", false)
      return ""
    end
  end
end, ns)

if LAZY then
  rmv({ "n", "v", "i" }, "<A-j>")
end
-- bufferline.nvim
add(n, "<M-j>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
add(n, "<M-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
add({ "i", "s" }, "<M-j>", "<C-o><cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
add({ "i", "s" }, "<M-l>", "<C-o><cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
add(n, "<M-S-j>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move Buffer Left" })
add(n, "<M-S-l>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move Buffer Right" })
add({ "i", "s" }, "<M-S-j>", "<C-o><cmd>BufferLineMovePrev<cr>", { desc = "Move Buffer Left" })
add({ "i", "s" }, "<M-S-l>", "<C-o><cmd>BufferLineMoveNext<cr>", { desc = "Move Buffer Right" })

if LAZY then
  rmv("n", "gco")
  rmv("n", "gcO")
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
add({ "i", "c" }, "<C-BS>", "<C-w>", { desc = "Delete Word", silent = true }) -- only for gui (no control code)

if LAZY then
  rmv("n", "<leader><tab>l")
  rmv("n", "<leader><tab>f")
  rmv("n", "<leader><tab>]")
  rmv("n", "<leader><tab>[")
end
add("n", "<leader><tab>L", "<cmd>tablast<cr>", { desc = "Last Tab" })
add("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
add("n", "<leader><tab>J", "<cmd>tabfirst<cr>", { desc = "First Tab" })
add("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
add("n", "<leader><tab>l", "<cmd>tabnext<cr>", { desc = "Next Tab" })
add("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
add("n", "<leader><tab>j", "<cmd>tabprevious<cr>", { desc = "Prev Tab" })

add("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Normal Mode", silent = true })

if LAZY then -- idk what's the source that sets the <leader>fn keymap
  rmv("n", "<leader>fn")
end
add("n", "<leader>fn", function()
  local cur_dir = vim.fn.expand("%:p:h")
  local new_name = vim.fn.input("New file: ", "", "file")
  if new_name ~= "" then
    local new_path = cur_dir .. "/" .. new_name
    vim.cmd("edit " .. new_path)
  end
end, { silent = true, desc = "New File (here)" })
add("n", "<leader>fN", function()
  local root_dir = require("lazyvim.util").root()
  local new_name = vim.fn.input("New file: ", "", "file")
  if new_name ~= "" then
    local new_path = root_dir .. "/" .. new_name
    vim.cmd("edit " .. new_path)
  end
end, { silent = true, desc = "New File (root dir)" })

-- w diagnostics
local cached_virtual_lines = nil
local cached_virtual_text = nil

require("snacks")
  .toggle({
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
  })
  :map("<leader>uv")
