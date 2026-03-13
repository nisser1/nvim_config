# Neovim Configuration

我的个人 Neovim 配置，基于现代插件系统构建的高效编辑环境。

## 特性

- 基于 Lua 编写的现代化配置
- 使用 lazy.nvim 管理插件
- 优化的代码补全 (cmp)
- LSP 配置 (lspconfig)
- Tree-sitter 语法高亮
- Telescope 搜索功能
- Git 集成 (gitsigns)

## 安装

1. 备份原有的 nvim 配置（如果存在）  
   `mv ~/.config/nvim ~/.config/nvim.bak`
   
2. 克隆此配置  
   `git clone git@github.com:nisser1/nvim_config.git ~/.config/nvim`

3. 打开 nvim 并等待插件自动安装  
   `nvim`

## 主要配置文件

- `init.lua` - 主要的启动文件
- `lua/plugins/` - 各种插件的详细配置
  - `cmp.lua` - 代码补全配置
  - `treesitter.lua` - 语法高亮配置
  - `lspconfig.lua` - LSP 服务配置
  - `telescope.lua` - 模糊搜索配置
  - `gitsigns.lua` - Git 集成配置
  - `colorscheme.lua` - 颜色主题配置
  - `mason.lua` - LSP/调试器/语法检查工具包管理

## 插件管理

本配置使用 lazy.nvim 作为插件管理器，具有快速启动时间及高效的插件延迟加载机制。

## 自定义设置

你可以通过修改 `lua/plugins/` 目录下的相应文件来定制特定插件的行为。如有需要额外的功能，可自行添加对应的插件配置。