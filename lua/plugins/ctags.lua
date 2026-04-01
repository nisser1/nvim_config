-- gtags配置（使用vim-gutentags的gtags_cscope模块自动生成）
-- 直接使用global命令进行代码导航
return {
  'ludovicchabant/vim-gutentags',
  enabled = true,
  config = function()
    -- =====================================
    -- Gutentags gtags_cscope 配置
    -- =====================================
    
    -- 禁用gutentags自动生成（使用手动 :GenGTags）
    vim.g.gutentags_enabled = 0
    
-- 项目根目录标记
    vim.g.gutentags_project_root = { '.git', '.gitignore', '.root', '.project', '.hg', '.svn' }
    
    -- =====================================
    -- 核心查询函数
    -- =====================================
    
    -- 查找项目根目录（gutentags识别的项目根）
    local function find_project_root()
      local current = vim.fn.expand('%:p:h')
      local markers = vim.g.gutentags_project_root or { '.git', '.root', '.project' }
      
      while current ~= '/' and current ~= '' do
        for _, marker in ipairs(markers) do
          if vim.fn.isdirectory(current .. '/' .. marker) == 1 or
             vim.fn.filereadable(current .. '/' .. marker) == 1 then
            return current
          end
        end
        current = vim.fn.fnamemodify(current, ':h')
      end
      
      return vim.fn.getcwd()
    end
    
    -- 查找GTAGS数据库路径（项目目录）
    local function find_gtags_db()
      local project_root = find_project_root()
      
      -- 检查项目根目录
      if vim.fn.filereadable(project_root .. '/GTAGS') == 1 then
        return project_root, project_root
      end
      
      return nil, project_root
    end
    
    -- 执行global命令并返回结果
    local function run_global(args)
      -- 检查global命令是否存在
      if vim.fn.executable('global') ~= 1 then
        return nil, "global command not found. Install: sudo apt install global"
      end
      
      -- 找到GTAGS数据库目录
      local db_dir, project_root = find_gtags_db()
      if not db_dir then
        return nil, "GTAGS not found. Opening a project file will auto-generate it, or run :GenGTags"
      end
      
      -- 设置环境变量并执行global命令
      local env_prefix = string.format('GTAGSDBPATH=%s GTAGSROOT=%s ', db_dir, project_root)
      local cmd = env_prefix .. string.format('global %s', args)
      local output = vim.fn.systemlist(cmd)
      
      if vim.v.shell_error ~= 0 then
        return nil, "global command failed"
      end
      
      return output, project_root
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
        vim.cmd('botright copen')
        vim.keymap.set('n', '<CR>', '<CR>:cclose<CR>', { buffer = true, silent = true })
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
    
-- 生成GTAGS（手动触发，作为gutentags的补充）
    vim.api.nvim_create_user_command('GenGTags', function(opts)
      local target_dir = opts.args ~= '' and vim.fn.expand(opts.args) or vim.fn.getcwd()
      local project_root = find_project_root()
      
      vim.notify("Generating GTAGS in " .. project_root, vim.log.levels.INFO)
      
      local cmd
      if vim.fn.filereadable(project_root .. '/GTAGS') == 1 then
        cmd = string.format('cd "%s" && gtags -i', project_root)
      else
        cmd = string.format('cd "%s" && gtags', project_root)
      end
      
      vim.notify("Generating GTAGS in " .. project_root, vim.log.levels.INFO)
      
      local cmd
      if vim.fn.filereadable(project_root .. '/GTAGS') == 1 then
        cmd = string.format('cd "%s" && gtags -i', project_root)
      else
        cmd = string.format('cd "%s" && gtags', project_root)
      end
      
      vim.fn.jobstart(cmd, {
        cwd = project_root,
        on_exit = function(_, code)
          vim.schedule(function()
            if code == 0 then
              vim.notify("GTAGS generated in " .. project_root, vim.log.levels.INFO)
            else
              vim.notify("Failed to generate GTAGS. Install: sudo apt install global", vim.log.levels.ERROR)
            end
          end)
        end
      })
    end, { nargs = '?', desc = 'Generate GTAGS for current project (optional: specify directory)' })
    
    -- 状态检查
    vim.api.nvim_create_user_command('GtagsStatus', function()
      local project_root = find_project_root()
      local db_dir, _ = find_gtags_db()
      local lines = {}
      
      table.insert(lines, "=== GTAGS Status ===")
      table.insert(lines, "global: " .. (vim.fn.executable('global') == 1 and "✓" or "✗ not found"))
      table.insert(lines, "gtags: " .. (vim.fn.executable('gtags') == 1 and "✓" or "✗ not found"))
      table.insert(lines, "gutentags: " .. (vim.g.gutentags_enabled == 1 and "✓ enabled" or "✗ disabled"))
      
      if project_root then
        table.insert(lines, "")
        table.insert(lines, "Project Root: " .. project_root)
      end
      
      if db_dir then
        table.insert(lines, "GTAGS DB: " .. db_dir)
        table.insert(lines, "GTAGS: " .. (vim.fn.filereadable(db_dir .. '/GTAGS') == 1 and "✓" or "✗"))
        table.insert(lines, "GRTAGS: " .. (vim.fn.filereadable(db_dir .. '/GRTAGS') == 1 and "✓" or "✗"))
        table.insert(lines, "GPATH: " .. (vim.fn.filereadable(db_dir .. '/GPATH') == 1 and "✓" or "✗"))
      else
        table.insert(lines, "")
        table.insert(lines, "GTAGS: ✗ not found")
        if vim.g.gutentags_enabled == 1 then
          table.insert(lines, "Open a project file to auto-generate, or run :GenGTags")
        else
          table.insert(lines, "Run :GenGTags to generate manually")
        end
      end
      
      vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
    end, { desc = 'Check GTAGS status' })
    
    -- 直接搜索命令
    vim.api.nvim_create_user_command('Gtags', function(opts)
      if opts.args and opts.args ~= '' then
        gtags_search('-x ' .. opts.args)
      end
    end, { nargs = '*', desc = 'Search with GTAGS' })
    
    -- 自动生成/更新：打开项目文件时检查
    -- 只在不存在或过期（超过4小时）时才更新
    local AUTO_UPDATE_HOURS = 4  -- 自动更新间隔（小时）
    
    vim.api.nvim_create_autocmd('BufReadPost', {
      pattern = { '*.c', '*.h', '*.cpp', '*.hpp', '*.cc', '*.cxx', '*.py', '*.java', '*.js', '*.ts' },
      callback = function()
        local project_root = find_project_root()
        local gtags_file = project_root .. '/GTAGS'
        
        if vim.fn.filereadable(gtags_file) == 0 then
          -- 不存在：生成新的
          vim.notify("Generating GTAGS for " .. project_root .. " ...", vim.log.levels.INFO)
          vim.fn.jobstart({'gtags'}, {
            cwd = project_root,
            on_exit = function(_, code)
              vim.schedule(function()
                if code == 0 then
                  vim.notify("GTAGS generated successfully", vim.log.levels.INFO)
                else
                  vim.notify("Failed to generate GTAGS", vim.log.levels.WARN)
                end
              end)
            end
          })
        else
          -- 存在：检查是否过期
          local gtags_mtime = vim.fn.getftime(gtags_file)
          local current_time = vim.fn.localtime()
          local hours_old = (current_time - gtags_mtime) / 3600  -- 秒转小时
          
          if hours_old > AUTO_UPDATE_HOURS then
            vim.notify(string.format("GTAGS is %.1f hours old, updating...", hours_old), vim.log.levels.INFO)
            vim.fn.jobstart({'gtags', '-i'}, {  -- -i 增量更新
              cwd = project_root,
              on_exit = function(_, code)
                vim.schedule(function()
                  if code == 0 then
                    vim.notify("GTAGS updated successfully", vim.log.levels.INFO)
                  else
                    vim.notify("Failed to update GTAGS", vim.log.levels.WARN)
                  end
                end)
              end
            })
          end
        end
      end,
      group = vim.api.nvim_create_augroup('AutoGenGTags', { clear = true })
    })
  end
}