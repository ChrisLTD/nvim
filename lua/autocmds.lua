-- trim whitespace
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		if not vim.bo.modifiable then
			return
		end
		-- keeppatterns: don't clobber the last search pattern;
		-- winsaveview: restore scroll position as well as the cursor.
		local view = vim.fn.winsaveview()
		vim.cmd([[keeppatterns %s/\s\+$//e]])
		vim.fn.winrestview(view)
	end,
})

-- Refresh statusline when diagnostics change so the counter stays current
-- even while idle (e.g. LSP publishes a result after a save).
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.cmd("redrawstatus")
	end,
})
