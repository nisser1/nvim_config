return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim',
  },
  config = function()
    local telescope = require('telescope')
    telescope.setup({
      defaults = {
        layout_strategy = 'horizontal',
        layout_config = { prompt_position = 'top' },
        sorting_strategy = 'ascending',
        file_ignore_patterns = { 'build/', 'dist/', '.git/', 'vendor/', 'node_modules/' },
      },
    })

    -- 快捷键绑定
    vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>', { desc = 'Find files' })
    vim.keymap.set('n', '<C-f>', ':Telescope live_grep<CR>', { desc = 'Live grep' })
    -- LSP相关快捷键已禁用（当前不使用LSP）
    -- vim.keymap.set('n', '<C-r>', ':Telescope lsp_references<CR>', { desc = 'LSP References' })
    -- vim.keymap.set('n', '<C-d>', ':Telescope lsp_definitions<CR>', { desc = 'LSP Definitions' })
    -- vim.keymap.set('n', '<C-i>', ':Telescope lsp_implementations<CR>', { desc = 'LSP Implementations' })
    -- vim.keymap.set('n', '<C-s>', ':Telescope lsp_document_symbols<CR>', { desc = 'Document Symbols' })
    -- vim.keymap.set('n', '<C-t>', ':Telescope lsp_type_definitions<CR>', { desc = 'Type Definitions' })
  end,
}