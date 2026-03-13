return {
  'ludovicchabant/vim-gutentags',  -- 启用gtags功能替代ctags
  enabled = true,
  config = function()
    -- 启用gtags和gtags-cscope设置（禁用ctags）
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
  end
}