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

    vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>', { desc = 'Find files' })
    vim.keymap.set('n', '<C-f>', ':Telescope live_grep<CR>', { desc = 'Live grep' })
  end,
}