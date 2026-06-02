-- trim whitespace
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    callback = function()
      local pos = vim.api.nvim_win_get_cursor(0)
      vim.cmd([[%s/\s\+$//e]])
      vim.api.nvim_win_set_cursor(0, pos)
    end,
})

-- Refresh statusline when diagnostics change so the counter stays current
-- even while idle (e.g. LSP publishes a result after a save).
vim.api.nvim_create_autocmd('DiagnosticChanged', {
    callback = function() vim.cmd('redrawstatus') end,
})
