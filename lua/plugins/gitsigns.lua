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
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        -- 显示当前行的 Git 提交信息
        vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame, { buffer = bufnr })

        -- 跳转到上一个/下一个变更
        vim.keymap.set('n', ']c', gs.next_hunk, { buffer = bufnr })
        vim.keymap.set('n', '[c', gs.prev_hunk, { buffer = bufnr })

        -- 暂存/取消暂存 hunk
        vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr })
        vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr })
      end,
    }
  end
}