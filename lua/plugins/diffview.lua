return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
	config = function()
		vim.keymap.set("n", "<leader>dvo", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" })
		vim.keymap.set("n", "<leader>dvc", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })
		vim.keymap.set("n", "<leader>dvh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview file history (current file)" })
		vim.keymap.set("n", "<leader>dvH", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview file history (repo)" })
	end,
}
