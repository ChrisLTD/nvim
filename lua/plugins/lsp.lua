return {
    { 'mason-org/mason.nvim', opts = {} },

    {
      'mason-org/mason-lspconfig.nvim',
      dependencies = { 'neovim/nvim-lspconfig', 'saghen/blink.cmp' },
      opts = {
        ensure_installed = { 'ts_ls', 'gopls' },
      },
      config = function(_, opts)
        require('mason-lspconfig').setup(opts)

        vim.lsp.config('*', {
          capabilities = require('blink.cmp').get_lsp_capabilities(),
        })
        vim.lsp.enable({ 'ts_ls', 'gopls' })

        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(event)
            local o = { buffer = event.buf }

            -- Jump to where the symbol is defined
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, o)

            -- Jump to the declaration
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, o)

            -- List all references to the symbol under cursor
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, o)

            -- Jump to the implementation
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, o)

            -- Show hover documentation
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, o)

            -- Rename the symbol under cursor across the project
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, o)

            -- Show available code actions (quick fixes, refactors)
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, o)

            -- Format the current buffer
            vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, o)

            -- Jump to previous diagnostic
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, o)

            -- Jump to next diagnostic
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, o)

            -- Show diagnostic details in a floating window
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, o)
          end,
        })
      end,
    },
}
