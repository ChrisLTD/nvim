-- Visual browser for undo history (pairs with persistent undo in set.lua)
return {
	"mbbill/undotree",
	config = function()
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
	end,
}
