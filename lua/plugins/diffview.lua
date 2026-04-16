return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
	config = function()
		vim.keymap.set("n", "<leader>gvo", "<cmd>DiffviewOpen<cr>", { desc = "Diffview open" })
		vim.keymap.set("n", "<leader>gvc", "<cmd>DiffviewClose<cr>", { desc = "Diffview close" })
		vim.keymap.set("n", "<leader>gvh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview file history (current file)" })
		vim.keymap.set("n", "<leader>gvH", "<cmd>DiffviewFileHistory<cr>", { desc = "Diffview file history (repo)" })
	end,
}
