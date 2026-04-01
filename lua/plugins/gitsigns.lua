return {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPre',
  config = function()
    require('gitsigns').setup {
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 100,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      current_line_blame_formatter_opts = {
        relative_time = false,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        
        vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame, { buffer = bufnr, desc = '切换 blame 显示' })
        
        vim.keymap.set('n', ']c', gs.next_hunk, { buffer = bufnr, desc = '下一个变更' })
        vim.keymap.set('n', '[c', gs.prev_hunk, { buffer = bufnr, desc = '上一个变更' })
        
        vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = '暂存 hunk' })
        vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr, desc = '取消暂存 hunk' })
      end,
    }
    
    vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { 
      fg = '#fabd2f',
      bg = 'NONE',
      bold = false,
      italic = true,
    })
  end
}