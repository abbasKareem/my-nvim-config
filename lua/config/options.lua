-- Options matching VS Code settings.json
local opt = vim.opt

-- Line numbers (editor.lineNumbers: "relative")
opt.relativenumber = true
opt.number = true

-- Scroll context (editor.cursorSurroundingLines: 8)
opt.scrolloff = 8

-- No word wrap
opt.wrap = false

-- System clipboard (vim.useSystemClipboard: true)
opt.clipboard = "unnamedplus"

-- Search (vim.hlsearch + vim.incsearch)
opt.hlsearch = true
opt.incsearch = true

-- Always show sign column
opt.signcolumn = "yes"

-- Highlight current line
opt.cursorline = true

-- True color
opt.termguicolors = true

-- Don't show mode (statusline shows it)
opt.showmode = false

-- Indentation (2 spaces like VS Code prettier defaults)
opt.smartindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2

-- Search behavior
opt.ignorecase = true
opt.smartcase = true

-- Window splits
opt.splitright = true
opt.splitbelow = true

-- Mouse
opt.mouse = "a"

-- Persistent undo
opt.undofile = true

-- Performance
opt.updatetime = 200
opt.timeoutlen = 300

-- No minimap equivalent needed (editor.minimap.enabled: false)
-- Sticky scroll disabled (editor.stickyScroll.enabled: false) — not enabled by default
