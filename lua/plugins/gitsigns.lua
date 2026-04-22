return {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPre',
  config = function()
    local gitsigns = require('gitsigns')
    
    gitsigns.setup {
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 300,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
      watch_gitdir = {
        enable = true,
        follow_files = true,
      },
      attach_to_untracked = true,
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
    
    vim.api.nvim_create_autocmd('BufReadPost', {
      pattern = '*',
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local file_path = vim.api.nvim_buf_get_name(bufnr)
        
        if file_path == '' or not vim.fn.filereadable(file_path) then
          return
        end
        
        local cwd = vim.fn.getcwd()
        local file_dir = vim.fn.fnamemodify(file_path, ':p:h')
        
        local git_dir_in_cwd = vim.fn.finddir('.git', cwd .. ';')
        local git_dir_in_file = vim.fn.finddir('.git', file_dir .. ';')
        
        if git_dir_in_file and not git_dir_in_cwd then
          local gitdir = vim.fn.fnamemodify(git_dir_in_file, ':p')
          vim.schedule(function()
            gitsigns.attach(bufnr, {gitdir = gitdir})
          end)
        end
      end,
      group = vim.api.nvim_create_augroup('GitsignsSmartAttach', { clear = true }),
    })
  end
}