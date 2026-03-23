-- Keymaps matching VS Code settings.json and keybindings.json
-- Leader is <Space> (set in lazy.lua)
local map = vim.keymap.set

-- ======================== WINDOW NAVIGATION (C-k / C-j) ========================
-- Move focus between editor and bottom panels (references, quickfix, trouble, etc.)

-- ======================== NORMAL MODE ========================

-- Save file (<leader>w → :w | Ctrl+s → save)
map("n", "<leader>w", "<cmd>w<cr><esc>", { desc = "Save file", nowait = true })
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save" })

-- Quit (<leader>q, <leader><leader> → :q | tt → close buffer like VS Code tab close)
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit", nowait = true })
-- map("n", "<leader><leader>", "<cmd>q<cr>", { desc = "Quit" })
map("n", "tt", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- Toggle terminal (<leader>d / Ctrl+d / Ctrl+Shift+d)
map("n", "<leader>d", function() Snacks.terminal() end, { desc = "Toggle terminal" })
map("n", "<C-d>", function() Snacks.terminal() end, { desc = "Toggle terminal" })

-- Zen mode (z → ZenMode)
map("n", "z", "<cmd>ZenMode<cr>", { desc = "Zen Mode" })

-- Move lines up/down (J/K → move line)
map("n", "J", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "K", "<cmd>m .-2<cr>==", { desc = "Move line up" })

-- Duplicate line down (P → copy line below)
map("n", "P", "<cmd>t.<cr>", { desc = "Duplicate line down" })

-- Jump to matching bracket (<leader>j / <leader>k)
map("n", "<leader>j", "%", { desc = "Jump to matching bracket" })
map("n", "<leader>k", "%", { desc = "Jump to matching bracket" })

-- Go to line (<leader>g → command mode to type line number)
map("n", "<leader>g", ":", { desc = "Go to line", nowait = true })

-- Go to references (gg → references, falls back to normal gg in special buffers)
map("n", "gg", function()
  if vim.bo.buftype ~= "" then
    vim.cmd("normal! gg")
    return
  end
  vim.lsp.buf.references()
end, { desc = "Go to references" })

-- ======================== EXPLORER TOGGLE ========================
local function toggle_explorer()
  local existing = Snacks.picker.get({ source = "explorer" })
  if #existing > 0 then
    existing[1]:close()
  else
    Snacks.explorer.open()
  end
end

-- File explorer (<leader>a → toggle explorer)
map("n", "<leader>a", toggle_explorer, { desc = "Toggle explorer" })

-- Toggle sidebar/explorer (<leader>e, Ctrl+e, Ctrl+Shift+h → all toggle explorer)
-- <leader>e and <leader>E are disabled in overrides.lua so LazyVim never registers them
map("n", "<leader>e", toggle_explorer, { desc = "Toggle explorer" })
map("n", "<C-e>", toggle_explorer, { desc = "Toggle explorer" })
map("n", "<C-S-h>", toggle_explorer, { desc = "Toggle explorer" })

-- Buffer switcher (<leader>f / Shift+C → like VS Code quickOpenPreviousRecentlyUsedEditorInGroup)
-- Opens MRU buffer list with the 2nd item (previous buffer) pre-selected, so Enter switches immediately.
local function open_buffer_switcher()
  Snacks.picker.buffers({
    sort_lastused = true,
    on_show = function(picker)
      -- Move cursor to 2nd item (the previous buffer, since 1st is current)
      vim.schedule(function()
        picker.list:move(2, true)
      end)
    end,
  })
end

-- config/keymaps.lua loads during VeryLazy, so we defer to run after it completes
vim.schedule(function()
  vim.defer_fn(function()
    -- Delete every <leader>f* mapping that exists
    local all_maps = vim.api.nvim_get_keymap("n")
    for _, m in ipairs(all_maps) do
      if m.lhs:sub(1, 2) == " f" and #m.lhs > 2 then
        pcall(vim.keymap.del, "n", m.lhs)
      end
    end
    -- Set our mapping
    map("n", "<leader>f", open_buffer_switcher, { desc = "Switch buffer" })
    map("v", "<leader>f", open_buffer_switcher, { desc = "Switch buffer" })
  end, 100)
end)

-- Shift+C → recent buffer (same as <leader>f in VS Code)
map("n", "C", open_buffer_switcher, { desc = "Switch buffer" })

-- Hover / definition preview (F / Shift+F → hover info)
map("n", "F", function() vim.lsp.buf.hover() end, { desc = "Hover info" })

-- Search word under cursor (f → * like VS Code find next occurrence)
map("n", "f", "*", { desc = "Search word under cursor" })

-- Change inner word (cc → ciw)
map("n", "cc", "ciw", { desc = "Change inner word" })

-- Visual line mode (vv → V)
map("n", "vv", "V", { desc = "Visual line" })

-- Go to references/usages (Enter → show all usages like VS Code, same as gg)
map("n", "<CR>", function()
  if vim.bo.buftype ~= "" then
    local key = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
    vim.api.nvim_feedkeys(key, "n", false)
    return
  end
  vim.lsp.buf.references()
end, { desc = "Go to references" })

-- Go to definition in split (Ctrl+Enter → vsplit + definition)
map("n", "<C-CR>", function()
  vim.cmd("vsplit")
  vim.lsp.buf.definition()
end, { desc = "Definition in split" })

-- Fold / Unfold (<leader>t → fold, <leader>r → unfold)
map("n", "<leader>t", "zc", { desc = "Fold", nowait = true })
map("n", "<leader>r", "zo", { desc = "Unfold" })

-- Delete character without yanking (x)
map("n", "x", '"_x', { desc = "Delete char" })

-- Buffer navigation (Tab / S-Tab → next/prev buffer)
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })

-- Line start / end (<leader>h → _, <leader>l → $)
map("n", "<leader>h", "_", { desc = "Start of line" })
map("n", "<leader>l", "$", { desc = "End of line" })

-- Comment toggle (<leader>/ and Ctrl+/)
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })
map("n", "<C-/>", "gcc", { remap = true, desc = "Toggle comment" })

-- File finder (Ctrl+p → find files, like VS Code quick open)
map("n", "<C-p>", function() Snacks.picker.files() end, { desc = "Find files" })

-- Search in file (Ctrl+f)
map("n", "<C-f>", "/", { desc = "Search in file" })

-- Find in files / grep (Ctrl+Shift+f)
map("n", "<C-S-f>", function() Snacks.picker.grep() end, { desc = "Find in files" })

-- New file (Ctrl+n)
map("n", "<C-n>", "<cmd>enew<cr>", { desc = "New file" })

-- Redo (Ctrl+y)
map("n", "<C-y>", "<C-r>", { desc = "Redo" })

-- Window navigation (Ctrl+k → focus window above, Ctrl+j → focus window below)
-- Use this to move between editor and the references/quickfix panel at the bottom
map("n", "<C-k>", "<C-w>k", { desc = "Focus window above" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus window below" })

-- Marks (Ctrl+m → show marks)
map("n", "<C-m>", "<cmd>marks<cr>", { desc = "Show marks" })

-- Delete word forward (Alt+Backspace → dw in normal mode)
map("n", "<M-BS>", "dw", { desc = "Delete word" })

-- Organize imports (Ctrl+o)
map("n", "<C-o>", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = { only = { "source.organizeImports" }, diagnostics = {} },
  })
end, { desc = "Organize imports" })

-- Code action / quick fix (Ctrl+.)
map("n", "<C-.>", function() vim.lsp.buf.code_action() end, { desc = "Code action" })

-- Split editor (Ctrl+Shift+Enter → vertical split)
map("n", "<C-S-CR>", "<cmd>vsplit<cr>", { desc = "Split editor" })

-- Git status (Ctrl+Shift+b → lazygit)
map("n", "<C-S-b>", function() Snacks.lazygit() end, { desc = "Git status" })

-- Diagnostics list (Ctrl+Shift+m → trouble diagnostics)
map("n", "<C-S-m>", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })

-- Select to matching bracket (Ctrl+Shift+[)
map("n", "<C-S-[>", "v%", { desc = "Select to bracket" })

-- Window navigation (Ctrl+h/l → focus prev/next window, matching VS Code split navigation)
-- LazyVim already maps <C-h/j/k/l> but we override C-j/C-k above for zoom.
-- Ctrl+l / Ctrl+h for window left/right are kept from LazyVim defaults.

-- ======================== INSERT MODE ========================

-- Escape shortcuts (jk / jj → Escape)
map("i", "jk", "<Esc>", { desc = "Escape" })
map("i", "jj", "<Esc>", { desc = "Escape" })

-- Save from insert mode
map("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save" })

-- Undo from insert mode
map("i", "<C-z>", "<Esc>ui", { desc = "Undo" })

-- Window navigation from insert mode (exit insert, then move window focus)
map("i", "<C-k>", "<Esc><C-w>k", { desc = "Focus window above" })
map("i", "<C-j>", "<Esc><C-w>j", { desc = "Focus window below" })

-- Explorer from insert mode (Ctrl+h → toggle explorer)
map("i", "<C-h>", toggle_explorer, { desc = "Toggle explorer" })

-- Delete word left (Ctrl+Backspace → delete word backwards)
map("i", "<C-BS>", "<C-w>", { desc = "Delete word left" })

-- ======================== VISUAL MODE ========================

-- Move lines (J/K → move selection up/down)
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move lines down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move lines up" })

-- Duplicate lines (P → copy selection below)
map("v", "P", ":'<,'>t'><cr>gv", { desc = "Duplicate lines" })

-- Stay in indent mode (> / < → indent and reselect)
map("v", ">", ">gv", { desc = "Indent" })
map("v", "<", "<gv", { desc = "Dedent" })

-- Visual line mode (vv → V)
map("v", "vv", "V", { desc = "Visual line" })

-- Search in file (/ → start search, f → search selection)
map("v", "/", "<Esc>/", { desc = "Search in file" })
map("v", "f", '"zy/<C-r>z<CR>', { desc = "Search selection" })

-- Change inner (cc → ci, then type the surround char like w, (, etc.)
map("v", "cc", "<Esc>ci", { desc = "Change inner" })

-- Window navigation from visual mode
map("v", "<C-k>", "<Esc><C-w>k", { desc = "Focus window above" })
map("v", "<C-j>", "<Esc><C-w>j", { desc = "Focus window below" })

-- Quit
map("v", "<leader><leader>", "<Esc><cmd>q<cr>", { desc = "Quit" })

-- Comment toggle
map("v", "<leader>/", "gc", { remap = true, desc = "Toggle comment" })
map("v", "<C-/>", "gc", { remap = true, desc = "Toggle comment" })

-- ======================== TERMINAL MODE ========================

-- Double Escape to exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Terminal navigation (Ctrl+h/l → next/prev terminal pane)
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Focus left" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Focus right" })

-- Terminal resize (Ctrl+Shift+s → up, Ctrl+Shift+a → down)
map("t", "<C-S-s>", "<cmd>resize +3<cr>", { desc = "Resize pane up" })
map("t", "<C-S-a>", "<cmd>resize -3<cr>", { desc = "Resize pane down" })
