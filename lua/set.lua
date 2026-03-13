-- =========================
-- Cursor
-- =========================

-- Use the terminal's default cursor style instead of Neovim's GUI cursor settings
vim.opt.guicursor = ""

-- =========================
-- Line Numbers
-- =========================

-- Show the absolute line number for the current line
vim.opt.number = true

-- Show relative line numbers for all other lines
-- Useful for motions like 5j or 3k
vim.opt.relativenumber = true

-- =========================
-- Tabs & Indentation
-- =========================

-- Number of spaces that a <Tab> counts for
vim.opt.tabstop = 4

-- Number of spaces inserted when pressing <Tab> in insert mode
vim.opt.softtabstop = 4

-- Number of spaces used for each step of (auto)indent
vim.opt.shiftwidth = 4

-- Convert tabs to spaces
vim.opt.expandtab = true

-- Enable smart auto-indenting when starting a new line
vim.opt.smartindent = true

-- Copy indentation from the current line when starting a new one
vim.opt.autoindent = true

-- Round indentation to multiples of shiftwidth
vim.opt.shiftround = true

-- =========================
-- Line Wrapping
-- =========================

-- Disable line wrapping (long lines extend horizontally)
vim.opt.wrap = false

-- =========================
-- Files, Backups, and Undo
-- =========================

-- Disable swap files (temporary crash recovery files)
vim.opt.swapfile = false

-- Disable backup files
vim.opt.backup = false

-- Store persistent undo history in this directory
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Enable persistent undo between sessions
vim.opt.undofile = true

-- Automatically reload files changed outside of Neovim
vim.opt.autoread = true

-- Ask for confirmation instead of failing when unsaved changes exist
vim.opt.confirm = true

-- =========================
-- Search Behavior
-- =========================

-- Do not highlight all matches after a search completes
vim.opt.hlsearch = false

-- Show matches incrementally while typing a search
vim.opt.incsearch = true

-- Ignore case when searching...
vim.opt.ignorecase = true

-- ...unless the search pattern contains uppercase letters
vim.opt.smartcase = true

-- Preview substitutions live in a split window
vim.opt.inccommand = "split"

-- =========================
-- Colors
-- =========================

-- Enable true color support (24-bit RGB)
vim.opt.termguicolors = true

-- =========================
-- Editor UI
-- =========================

-- Keep at least 8 lines visible above/below the cursor when scrolling
vim.opt.scrolloff = 8

-- Always show the sign column (used by git, diagnostics, etc.)
vim.opt.signcolumn = "yes"

-- Highlight the current line
vim.opt.cursorline = true

-- Draw a vertical guideline at column 80
vim.opt.colorcolumn = "80"

-- Status line
vim.opt.statusline = " %f %m %r %= %{FugitiveHead()} %l:%c "

-- =========================
-- Performance & Responsiveness
-- =========================

-- Faster update time for CursorHold events and plugins
vim.opt.updatetime = 50

-- Time to wait for a mapped sequence to complete
-- Lower values make key mappings feel more responsive
vim.opt.timeoutlen = 300

-- =========================
-- Window Splitting
-- =========================

-- Open vertical splits to the right
vim.opt.splitright = true

-- Open horizontal splits below
vim.opt.splitbelow = true

-- =========================
-- Clipboard & Input
-- =========================

-- Use the system clipboard for all yank, delete, and paste operations
vim.opt.clipboard = "unnamedplus"

-- Enable mouse support in all modes
vim.opt.mouse = "a"

-- =========================
-- Completion
-- =========================

-- Improve completion experience (used by LSP and completion plugins)
vim.opt.completeopt = "menuone,noselect"

-- =========================
-- Folding
-- =========================

-- Start with folds open (useful when folding is later managed by Treesitter/LSP)
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- =========================
-- File Name Handling
-- =========================

-- Allow '@' in filenames (useful for module imports)
vim.opt.isfname:append("@-@")
