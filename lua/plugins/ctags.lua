-- 纯gtags配置（不依赖vim-gutentags模块）
-- 直接使用global命令进行代码导航
return {
  'ludovicchabant/vim-gutentags',
  enabled = true,
  config = function()
    -- 不使用任何gutentags模块，我们手动处理gtags
    vim.g.gutentags_enabled = 0  -- 禁用gutentags自动功能
    
    -- =====================================
    -- 核心查询函数
    -- =====================================
    
    -- 查找项目根目录（GTAGS所在位置）
    local function find_gtags_root()
      local current = vim.fn.expand('%:p:h')
      while current ~= '/' and current ~= '' do
        if vim.fn.filereadable(current .. '/GTAGS') == 1 then
          return current
        end
        current = vim.fn.fnamemodify(current, ':h')
      end
      -- 也检查当前工作目录
      local cwd = vim.fn.getcwd()
      if vim.fn.filereadable(cwd .. '/GTAGS') == 1 then
        return cwd
      end
      return nil
    end
    
    -- 执行global命令并返回结果
    local function run_global(args)
      -- 检查global命令是否存在
      if vim.fn.executable('global') ~= 1 then
        return nil, "global command not found. Install: sudo apt install global"
      end
      
      -- 找到GTAGS根目录
      local root = find_gtags_root()
      if not root then
        return nil, "GTAGS not found. Run :GenGTags first."
      end
      
      -- 执行global命令
      local cmd = string.format('cd "%s" && global %s', root, args)
      local output = vim.fn.systemlist(cmd)
      
      if vim.v.shell_error ~= 0 then
        return nil, "global command failed"
      end
      
      return output, root
    end
    
    -- 解析global -x输出到quickfix格式
    -- 输出格式: 符号名 行号 文件名 上下文
    local function parse_to_qflist(lines, root)
      local qflist = {}
      for _, line in ipairs(lines) do
        if line and line ~= '' then
          local symbol, lnum, filename, context = line:match('^(%S+)%s+(%d+)%s+(%S+)%s*(.*)$')
          if filename and lnum then
            local fullpath = root .. '/' .. filename
            table.insert(qflist, {
              filename = fullpath,
              lnum = tonumber(lnum),
              text = context or '',
              valid = 1,
            })
          end
        end
      end
      return qflist
    end
    
    -- 执行gtags查询并跳转
    local function gtags_search(args)
      local output, result = run_global(args)
      
      if type(result) == 'string' and output == nil then
        -- result是错误信息
        vim.notify(result, vim.log.levels.WARN)
        return
      end
      
      local root = result
      if not output or #output == 0 then
        vim.notify("No results found", vim.log.levels.INFO)
        return
      end
      
      local qflist = parse_to_qflist(output, root)
      
      if #qflist == 0 then
        vim.notify("No valid results", vim.log.levels.INFO)
        return
      end
      
      -- 设置quickfix列表
      vim.fn.setqflist(qflist, 'r')
      
      if #qflist == 1 then
        vim.cmd('cfirst')
      else
        vim.cmd('copen')
        vim.notify(string.format("Found %d results", #qflist), vim.log.levels.INFO)
      end
    end
    
    -- =====================================
    -- 键盘映射
    -- =====================================
    
    local opts = { noremap = true, silent = true }
    
    -- ,gd - 跳转到定义
    vim.keymap.set('n', '<leader>gd', function()
      local cword = vim.fn.expand('<cword>')
      if cword == '' then return end
      gtags_search('-x -d ' .. cword)
    end, opts)
    
    -- ,gr - 查找引用
    vim.keymap.set('n', '<leader>gr', function()
      local cword = vim.fn.expand('<cword>')
      if cword == '' then return end
      gtags_search('-x -r ' .. cword)
    end, opts)
    
    -- ,gs - 查找符号
    vim.keymap.set('n', '<leader>gs', function()
      local cword = vim.fn.expand('<cword>')
      if cword == '' then return end
      gtags_search('-x -s ' .. cword)
    end, opts)
    
    -- ,gg - grep查找
    vim.keymap.set('n', '<leader>gg', function()
      local cword = vim.fn.expand('<cword>')
      if cword == '' then return end
      gtags_search('-x -g ' .. cword)
    end, opts)
    
    -- Quickfix导航
    vim.keymap.set('n', '<leader>gl', ':copen<CR>', opts)
    vim.keymap.set('n', '<leader>g]', ':cnext<CR>', opts)
    vim.keymap.set('n', '<leader>g[', ':cprev<CR>', opts)
    vim.keymap.set('n', '<leader>gq', ':cclose<CR>', opts)
    
    -- 后退 (使用 Ctrl+t 代替 Ctrl+o)
    vim.keymap.set('n', '<C-t>', '<C-o>', { noremap = true, silent = true, desc = 'Jump back' })
    -- 禁用原来的 Ctrl+o
    vim.keymap.set('n', '<C-o>', '<Nop>', { noremap = true, silent = true })
    
    -- =====================================
    -- 用户命令
    -- =====================================
    
    -- 生成GTAGS
    vim.api.nvim_create_user_command('GenGTags', function()
      local cwd = vim.fn.getcwd()
      vim.notify("Generating GTAGS in " .. cwd, vim.log.levels.INFO)
      
      vim.fn.jobstart('gtags', {
        cwd = cwd,
        on_exit = function(_, code)
          vim.schedule(function()
            if code == 0 then
              vim.notify("GTAGS generated!", vim.log.levels.INFO)
            else
              vim.notify("Failed to generate GTAGS. Install: sudo apt install global", vim.log.levels.ERROR)
            end
          end)
        end
      })
    end, { desc = 'Generate GTAGS for current project' })
    
    -- 状态检查
    vim.api.nvim_create_user_command('GtagsStatus', function()
      local root = find_gtags_root()
      local lines = {}
      
      table.insert(lines, "=== GTAGS Status ===")
      table.insert(lines, "global: " .. (vim.fn.executable('global') == 1 and "✓" or "✗ not found"))
      table.insert(lines, "gtags: " .. (vim.fn.executable('gtags') == 1 and "✓" or "✗ not found"))
      
      if root then
        table.insert(lines, "")
        table.insert(lines, "Root: " .. root)
        table.insert(lines, "GTAGS: " .. (vim.fn.filereadable(root .. '/GTAGS') == 1 and "✓" or "✗"))
        table.insert(lines, "GRTAGS: " .. (vim.fn.filereadable(root .. '/GRTAGS') == 1 and "✓" or "✗"))
        table.insert(lines, "GPATH: " .. (vim.fn.filereadable(root .. '/GPATH') == 1 and "✓" or "✗"))
      else
        table.insert(lines, "")
        table.insert(lines, "GTAGS: ✗ not found")
        table.insert(lines, "Run :GenGTags to generate")
      end
      
      vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
    end, { desc = 'Check GTAGS status' })
    
    -- 直接搜索命令
    vim.api.nvim_create_user_command('Gtags', function(opts)
      if opts.args and opts.args ~= '' then
        gtags_search('-x ' .. opts.args)
      end
    end, { nargs = '*', desc = 'Search with GTAGS' })
  end
}