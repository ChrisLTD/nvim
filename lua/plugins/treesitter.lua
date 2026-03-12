return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  opts = {                                                                                                                    
    ensure_installed = {
      'javascript', 'typescript', 'tsx', 'go', 'gomod', 'gosum',
      'html', 'css', 'json', 'lua', 'vim', 'vimdoc',                                                                          
    },                                                                                                                        
    highlight = { enable = true },                                                                                            
    indent = { enable = true },                                                                                               
  },
}
