return {
  'ludovicchabant/vim-gutentags',  -- 启用gtags功能
  enabled = true,
  config = function()
    -- 启用gtags和gtags-cscope设置（只启用gtags相关模块）
    vim.g.gutentags_modules = {
      'gtags_cscope',  -- 启用gtags-cscope作为模块
      'gtags'          -- 同时启用gtags功能
    }

    -- 配置 gutentags 缓存目录
    vim.g.gutentags_cache_dir = vim.fn.expand('~/.cache/tags')

    -- 不配置ctags参数，仅针对gtags
    vim.g.gutentags_allowed_file_types = {
      '.c', '.cpp', '.h', '.hpp', '.java', 
      '.py', '.js', '.ts', '.go', '.rs', 
      '.lua', '.php', '.rb'
    }

    -- 启用 gtags 数据库自动添加
    vim.g.gutentags_auto_add_gtags_cscope = 1
    vim.g.gutentags_auto_add_gtags = 1

    -- 为 gtags 设置键盘映射
    local opts = { noremap = true, silent = true }

    -- 启用gtags专用映射
    vim.keymap.set("n", "<leader>gd", ":Gtags -d <C-r>=expand('<cword>')<CR><CR>", opts) -- 跳转到定义
    vim.keymap.set("n", "<leader>gr", ":Gtags -r <C-r>=expand('<cword>')<CR><CR>", opts) -- 查看引用
    vim.keymap.set("n", "<leader>gS", ":Gtags -s <C-r>=expand('<cword>')<CR><CR>", opts) -- 查找符号
    vim.keymap.set("n", "<leader>gf", ":Gtags -f <C-r>=expand('<cword>')<CR><CR>", opts) -- 查找文件
    vim.keymap.set("n", "<leader>gi", ":Gtags -gi<C-r>=expand('<cword>')<CR><CR>", opts) -- 查找导入
    vim.keymap.set("n", "<leader>gl", ":lopen<CR>", opts)                                  -- 打开位置列表
    vim.keymap.set("n", "<leader>g]", ":lnext<CR>", opts)                                  -- 下一个结果
    vim.keymap.set("n", "<leader>g[", ":lprev<CR>", opts)                                  -- 上一个结果

    -- 通用后退功能
    vim.keymap.set("n", "<C-t>", "<C-o>", opts)  -- 回退到上次位置

    -- 自动检查并生成gtags文件的函数
    local function check_and_generate_gtags()
      local cwd = vim.fn.getcwd()
      local has_git = vim.fn.isdirectory('.git') == 1 or vim.fn.finddir('.git', ';') ~= ''
      
      if has_git then
        local gtags_files_exist = 
          vim.fn.filereadable(cwd .. '/GTAGS') == 1 and
          vim.fn.filereadable(cwd .. '/GRTAGS') == 1 and
          vim.fn.filereadable(cwd .. '/GPATH') == 1
        
        if not gtags_files_exist then
          local confirm = vim.fn.input("GTAGS files not found. Generate now? (Y/n): ")
          
          if confirm == "" or confirm:lower():sub(1,1) == "y" then
            vim.notify("Generating GTAGS files...", vim.log.levels.INFO)
            
            vim.fn.jobstart({
              "gtags"
            }, {
              cwd = cwd,
              on_exit = function(_, exit_code, _)
                if exit_code == 0 then
                  vim.notify("GTAGS files generated successfully!", vim.log.levels.INFO)
                  -- 重新附加gtags数据库以使用新的符号数据库
                  vim.cmd("silent! Gtags -d")
                else
                  vim.notify("Failed to generate GTAGS (install gnu-global first)", vim.log.levels.WARN)
                end
              end
            })
          end
        end
      end
    end

    -- 当进入Git项目中的代码文件时，检查是否存在gtags文件
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        -- 延迟执行，以防vim刚启动时cwd未设置好
        vim.defer_fn(check_and_generate_gtags, 100)
      end,
      desc = "Check and generate gtags when opening vim in git repo"
    })

    vim.api.nvim_create_autocmd("DirChanged", {
      callback = function()
        check_and_generate_gtags()
      end,
      desc = "Check and generate gtags when changing directory"
    })

    vim.api.nvim_create_user_command("GenGTags", function()
      local cwd = vim.fn.getcwd()
      vim.notify("Generating GTAGS in " .. cwd, vim.log.levels.INFO)
      vim.fn.jobstart({
        "gtags"
      }, {
        cwd = cwd,
        on_exit = function(_, exit_code, _)
          if exit_code == 0 then
            vim.notify("GTAGS files generated successfully!", vim.log.levels.INFO)
          else
            vim.notify("Failed to generate GTAGS (install gnu-global first)", vim.log.levels.WARN)
          end
        end
      })
    end, { desc = "Manually generate gtags in current directory" })
  end
}