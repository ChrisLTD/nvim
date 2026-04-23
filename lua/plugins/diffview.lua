return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
	config = function()
		vim.keymap.set("n", "<leader>Do", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" })
		vim.keymap.set("n", "<leader>Dp", "<cmd>DiffviewOpen origin/main... --imply-local<cr>", { desc = "Diffview PR review (vs origin/main)" })
		vim.keymap.set("n", "<leader>Dc", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })
		vim.keymap.set("n", "<leader>Dh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview file history (current file)" })
		vim.keymap.set("n", "<leader>DH", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview file history (repo)" })
	end,
}
