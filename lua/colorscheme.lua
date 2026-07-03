-- Set theme
-- Comment out the line below to allow auto light/dark mode
-- vim.opt.background = "dark"
vim.cmd("colorscheme cyberdream")
-- vim.cmd("colorscheme oxocarbon")
-- vim.cmd("colorscheme rose-pine")

-- Set status line color
local function set_statusline_bg()
	local cursorline = vim.api.nvim_get_hl(0, { name = "CursorLine" })
	local normal = vim.api.nvim_get_hl(0, { name = "Normal" })

	vim.api.nvim_set_hl(0, "StatusLine", {
		bg = cursorline.bg or normal.bg,
	})
end

-- make sure the statusline bg is applied after all color scheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_statusline_bg,
})

-- The colorscheme was applied above, before the autocmd existed, so run the
-- fix once for the initial load as well.
set_statusline_bg()
