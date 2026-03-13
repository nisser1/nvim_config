return {
  'ludovicchabant/vim-gutentags',  -- 现在启用gtags和gtags-cscope功能替代LSP
  enabled = true,
  config = function()
    -- 启用 cscope 和 gtags 设置
    vim.g.gutentags_modules = {
      'ctags',
      'gtags_cscope',  -- 启用gtags-cscope作为模块
      'gtags'
    }

    -- 配置 gutentags 缓存目录
    vim.g.gutentags_cache_dir = vim.fn.expand('~/.cache/tags')

    -- 配置 ctags/Gtags 参数
    vim.g.gutentags_ctags_extra_args = {
      '--fields=+iazsS',  -- 扩展字段
      '--extra=+q',       -- 包含类/空间限定的标签
      '--c++-kinds=+px',  -- 包含额外的C++种类
      '--c-kinds=+px'     -- 包含额外的C种类
    }

    -- 启用 gtags 数据库自动添加
    vim.g.gutentags_auto_add_gtags_cscope = 1
    vim.g.gutentags_auto_add_gtags = 1

    -- 为 gtags 设置映射
    local opts = { noremap = true, silent = true }

    -- 启用 vim 本地标签映射以与 gtags 协作
    vim.keymap.set("n", "<C-]>", ":tag <C-R>=expand('<cword>')<CR><CR>", opts)
    vim.keymap.set("n", "<C-\\>", ":tselect <C-R>=expand('<cword>')<CR><CR>", opts)
    vim.keymap.set("n", "]t", ":tnext<CR>", opts)
    vim.keymap.set("n", "[t", ":tprev<CR>", opts)

    -- 启用gtags映射
    vim.keymap.set("n", "<leader>gd", ":Gtags -d <C-r>=expand('<cword>')<CR><CR>", opts) -- 跳转到定义
    vim.keymap.set("n", "<leader>gr", ":Gtags -r <C-r>=expand('<cword>')<CR><CR>", opts) -- 查看引用
    vim.keymap.set("n", "<leader>gS", ":Gtags -s <C-r>=expand('<cword>')<CR><CR>", opts) -- 查找符号
    vim.keymap.set("n", "<leader>gf", ":Gtags -f <C-r>=expand('<cword>')<CR><CR>", opts) -- 查找文件
    vim.keymap.set("n", "<leader>gi", ":Gtags -gi<C-r>=expand('<cword>')<CR><CR>", opts) -- 查找导入
    vim.keymap.set("n", "<leader>gl", ":copen<CR>", opts)                                   -- 打开位置列表
    vim.keymap.set("n", "<leader>g]", ":cnext<CR>", opts)                                    -- 下一个结果
    vim.keymap.set("n", "<leader>g[", ":cprev<CR>", opts)                                    -- 上一个结果

    -- 通用后退功能
    vim.keymap.set("n", "<C-t>", "<C-o>", opts)  -- 回退到上次位置
  end
}