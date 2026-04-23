return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gvo", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
		{ "<leader>gvp", "<cmd>DiffviewOpen origin/main... --imply-local<cr>", desc = "Diffview PR review (vs origin/main)" },
		{ "<leader>gvc", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
		{ "<leader>gvh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview file history (current file)" },
		{ "<leader>gvH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview file history (repo)" },
	},
}
