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
function StatuslineBranch()
	local branch = vim.fn.FugitiveHead()
	-- filter out common branch prefixes
	branch = branch:gsub("^chrisltd/", ""):gsub("^feature/eng%-", "")
	-- truncate long branch names
	return branch:sub(1, 30)
end

-- Path relative to the nearest .git ancestor (so it stays project-relative
-- regardless of cwd). Falls back to the filename when the buffer isn't in a
-- git repo. Always compacted with pathshorten 1 char per directory.
function StatuslinePath()
	local abs = vim.fn.expand("%:p")
	-- Unnamed buffers (dashboard, scratch, :new without a name) -> show nothing.
	if abs == "" then return "" end
	local root = vim.fs.root(0, { ".git" })
	local path
	if root and abs:sub(1, #root + 1) == root .. "/" then
		path = abs:sub(#root + 2)
	else
		-- :t = "tail" modifier -> just the filename, no directories.
		path = vim.fn.fnamemodify(abs, ":t")
	end
	return vim.fn.pathshorten(path, 1)
end

-- Current mode letter colored by mode family (reuses core syntax highlight
-- groups so it adapts to whichever colorscheme is active). Embed via %{%...%}.
function StatuslineMode()
	local m = vim.fn.mode()
	local hl_by_mode = {
		n       = "Function",        -- NORMAL
		i       = "String",          -- INSERT  (typically green)
		v       = "Constant",        -- VISUAL  (typically orange/magenta)
		V       = "Constant",        -- V-LINE
		["\22"] = "Constant",        -- V-BLOCK (CTRL-V)
		s       = "Constant",        -- SELECT
		S       = "Constant",
		["\19"] = "Constant",
		R       = "DiagnosticError", -- REPLACE (red)
		c       = "DiagnosticWarn",  -- COMMAND (yellow)
		t       = "String",          -- TERMINAL
	}
	local hl = hl_by_mode[m] or "Function"
	return "%#" .. hl .. "#" .. m:upper() .. "%*"
end

-- Modified flag: "[+]" in yellow when the buffer has unsaved changes, otherwise
-- empty. Replaces the built-in %m so we can color it. Embed via %{%...%}.
function StatuslineModified()
	if vim.bo.modified then return "%#DiagnosticWarn#[+]%*" end
	return ""
end

-- Error/warning counts for the current buffer, e.g. "E:2 W:1" with E in red and
-- W in yellow (reusing the built-in DiagnosticError / DiagnosticWarn highlight
-- groups so colors match virtual text and signs). Empty when clean.
-- Info and hint are intentionally omitted -- too noisy and rarely actionable.
-- Must be embedded in the statusline via %{%...%} (not %{...}) so the
-- %#Group# highlight markers in the returned string are interpreted.
function StatuslineDiagnostics()
	local s = vim.diagnostic.severity
	local counts = vim.diagnostic.count(0)
	local parts = {}
	if (counts[s.ERROR] or 0) > 0 then
		table.insert(parts, "%#DiagnosticError#E:" .. counts[s.ERROR] .. "%*")
	end
	if (counts[s.WARN] or 0) > 0 then
		table.insert(parts, "%#DiagnosticWarn#W:" .. counts[s.WARN] .. "%*")
	end
	return table.concat(parts, " ")
end

vim.opt.statusline = " %{%v:lua.StatuslineMode()%} %{v:lua.StatuslinePath()} %{%v:lua.StatuslineModified()%} %r %= %{v:lua.StatuslineBranch()} %P %{%v:lua.StatuslineDiagnostics()%} "

-- =========================
-- Performance & Responsiveness
-- =========================

-- Faster update time for CursorHold events and plugins
vim.opt.updatetime = 50

-- Time to wait for a mapped sequence to complete
-- Lower values make key mappings feel more responsive
-- Primeagen set it at 300
vim.opt.timeoutlen = 750

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

-- =========================
-- NetRW File Explorer changes
-- =========================

-- Disable banner
vim.g.netrw_banner = 0

-- Tree style view
vim.g.netrw_liststyle = 3

-- Don't open files in split
vim.g.netrw_browse_split = 0
