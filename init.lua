-- 设置 leader 键为逗号，以避免与其他组合键冲突
vim.g.mapleader = ","  -- 将 leader 键设置为逗号
vim.g.maplocalleader = "\\"  -- 使用反斜杠作为局部 leader 键

-- ==============================
-- 1. 引导 Lazy.nvim 安装与加载
-- ==============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 自动安装 Lazy.nvim（如果不存在）
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- 把 Lazy.nvim 加入 runtimepath
vim.opt.rtp:prepend(lazypath)
vim.opt.clipboard = 'unnamedplus' --可以和当前系统交互
vim.opt.mouse = "iv" --只有普通模式可以用鼠标copy内容，insert和visual模式不可以

-- ==============================
-- 2. 加载自定义配置模块 
-- ==============================
-- 基础配置：基本编辑设置（搜索高亮、行号、缩进等）
require("config.basic")

-- 诊断配置：控制LSP错误/警告标记的显示（E/W等）
-- 默认禁用显示标记，但仍保持LSP功能（如自动补全、跳转定义等）
-- 可通过命令临时切换：:DiagnosticsEnable/:DiagnosticsDisable/:DiagnosticsToggle
require("config.diagnostics")

-- 其他配置...

-- ==============================
-- 3. 初始化 Lazy.nvim 并加载插件
-- ==============================
local plugins = require("plugins").plugins
require("lazy").setup(plugins, {
  git = {
    timeout = 30000, -- 30秒超时（默认 5 秒）
  },
})



