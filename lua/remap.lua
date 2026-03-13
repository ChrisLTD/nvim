-- Set the "leader" key to Space.
-- Leader is a prefix used for your custom shortcuts, e.g. <leader>pv = <Space>pv
-- leader is set in lazy.lua
-- vim.g.mapleader = " "

-- Open netrw/file explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- In visual mode, move the selected block down one line,
-- then reselect it and reindent it.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- In visual mode, move the selected block up two lines,
-- then reselect it and reindent it.
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Run the current test file using Plenary's test runner.
-- Uses a <Plug> mapping, so noremap must be false.
vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

-- Join the current line with the next line,
-- but preserve cursor position by saving/restoring mark z.
vim.keymap.set("n", "J", "mzJ`z")

-- Scroll half a page down and then center the cursor line on screen.
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- Scroll half a page up and then center the cursor line on screen.
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Go to next search result, center it, and open folds if needed.
vim.keymap.set("n", "n", "nzzzv")

-- Go to previous search result, center it, and open folds if needed.
vim.keymap.set("n", "N", "Nzzzv")

-- Reindent "a paragraph" text object, then return cursor to original spot.
vim.keymap.set("n", "=ap", "ma=ap'a")

-- Restart the LSP client(s) for the current buffer/project.
vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- Paste over a visual selection without overwriting your unnamed register.
-- Very useful when replacing selected text with yanked text.
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank to the system clipboard in normal and visual mode.
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- Yank the current line to the system clipboard.
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete without copying into any register ("black hole" register).
-- Useful when you don't want deletions to overwrite your yank buffer.
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- Make Ctrl-c in insert mode behave like Escape.
-- Common personal preference, though not identical to real <Esc> in every case.
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable Ex mode, which is rarely used and easy to trigger accidentally.
vim.keymap.set("n", "Q", "<nop>")

-- Jump to next quickfix item and center the screen.
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")

-- Jump to previous quickfix item and center the screen.
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- Jump to next location list item and center the screen.
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")

-- Jump to previous location list item and center the screen.
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Start a search-and-replace for the word under cursor across the whole file.
-- Places cursor before the replacement flags so you can edit the command.
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Toggle between dark and light mode
vim.keymap.set("n", "<leader>dm", function()
	if vim.g.colors_name == "cyberdream" then
		vim.cmd("CyberdreamToggleMode")
	else
		if vim.o.background == "dark" then
			vim.o.background = "light"
		else
			vim.o.background = "dark"
		end
	end
end)
