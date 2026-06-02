return {
    { 'mason-org/mason.nvim', opts = {} },

    {
      'mason-org/mason-lspconfig.nvim',
      dependencies = { 'neovim/nvim-lspconfig', 'saghen/blink.cmp' },
      opts = {
        ensure_installed = { 'ts_ls', 'gopls', 'eslint' },
      },
      config = function(_, opts)
        require('mason-lspconfig').setup(opts)

        vim.lsp.config('*', {
          capabilities = require('blink.cmp').get_lsp_capabilities(),
        })
        vim.lsp.enable(opts.ensure_installed)

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

            -- Add missing imports (filetype-aware: gopls / ts_ls)
            vim.keymap.set('n', '<leader>ci', function()
              local kind_by_ft = {
                go              = 'source.organizeImports',
                typescript      = 'source.addMissingImports.ts',
                typescriptreact = 'source.addMissingImports.ts',
                javascript      = 'source.addMissingImports.ts',
                javascriptreact = 'source.addMissingImports.ts',
              }
              local kind = kind_by_ft[vim.bo.filetype]
              if not kind then
                vim.notify('No import action for filetype: ' .. vim.bo.filetype, vim.log.levels.WARN)
                return
              end
              vim.lsp.buf.code_action({
                context = { only = { kind }, diagnostics = {} },
                apply = true,
              })
            end, vim.tbl_extend('force', o, { desc = 'Add missing imports' }))

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

        -- Run gopls' organizeImports synchronously before save (goimports behavior)
        vim.api.nvim_create_autocmd('BufWritePre', {
          pattern = '*.go',
          callback = function()
            local params = vim.lsp.util.make_range_params(0, 'utf-8')
            params.context = { only = { 'source.organizeImports' }, diagnostics = {} }
            local results = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 3000)
            for cid, res in pairs(results or {}) do
              for _, action in pairs(res.result or {}) do
                if action.edit then
                  local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
                  vim.lsp.util.apply_workspace_edit(action.edit, enc)
                end
              end
            end
          end,
        })
      end,
    },
}
