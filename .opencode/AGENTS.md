# Neovim 配置项目规范

本项目是个人 Neovim 配置，基于 lazy.nvim 插件管理器。所有修改必须遵循以下规范。

## 项目结构

```
~/.config/nvim/
├── init.lua                    # 主入口，加载 lazy.nvim 和配置模块
├── lua/
│   ├── config/                 # 基础配置模块
│   │   ├── basic.lua           # 编辑器基础设置（行号、缩进、搜索等）
│   │   └── diagnostics.lua     # LSP 诊断控制
│   └── plugins/                # 插件配置（每个插件一个文件）
│       ├── init.lua            # 插件列表汇总
│       ├── cmp.lua             # 代码补全
│       ├── telescope.lua       # 模糊搜索
│       ├── treesitter.lua      # 语法高亮
│       ├── colorscheme.lua     # 主题
│       ├── gitsigns.lua        # Git 集成
│       ├── ctags.lua           # gtags 代码导航
│       ├── lspconfig.lua       # LSP 配置（当前禁用）
│       └── opencode.lua        # OpenCode 集成
```

## 快捷键规范

### 窗口导航
| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<C-h>` | n, t | 跳转到左侧窗口 |
| `<C-j>` | n, t | 跳转到下方窗口 |
| `<C-k>` | n, t | 跳转到上方窗口 |
| `<C-l>` | n, t | 跳转到右侧窗口 |

### 文件搜索 (Telescope)
| 快捷键 | 功能 |
|--------|------|
| `<C-p>` | 查找文件 |
| `<C-f>` | 全局搜索 (live_grep) |

### 代码导航 (gtags)
| 快捷键 | 功能 |
|--------|------|
| `<leader>gd` | 跳转到定义 |
| `<leader>gr` | 查找引用 |
| `<leader>gs` | 查找符号 |
| `<leader>gg` | grep 搜索 |
| `<leader>gl` | 打开 quickfix 列表 |
| `<leader>g]` | 下一个 quickfix 项 |
| `<leader>g[` | 上一个 quickfix 项 |
| `<leader>gq` | 关闭 quickfix |
| `<C-t>` | 返回跳转前位置 |

### Git (gitsigns)
| 快捷键 | 功能 |
|--------|------|
| `<leader>gb` | 显示当前行 blame |
| `]c` | 下一个变更 |
| `[c` | 上一个变更 |
| `<leader>hs` | 暂存 hunk |
| `<leader>hu` | 取消暂存 hunk |

### OpenCode
| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<F6>` | n, t | 切换 OpenCode 窗口 |
| `<leader><F6>` | n, t | 聚焦 OpenCode 输入框 |
| `<leader>o` | n, x | 打开 OpenCode 菜单 |
| `<leader>oa` | n, x | 向 OpenCode 提问 |
| `<leader>ot` | n, x | 切换 OpenCode |
| `<C-a>` | n, x | 提问 (@this:) |
| `<C-x>` | n, x | 选择操作 |
| `go` | n, x | 操作符模式添加范围 |
| `goo` | n | 添加当前行 |

### 代码补全 (nvim-cmp)
| 快捷键 | 功能 |
|--------|------|
| `<C-Space>` | 触发补全菜单 |
| `<C-b>` / `<C-f>` | 滚动文档 |
| `<C-e>` | 关闭补全菜单 |
| `<CR>` | 确认选择 |

### Visual 模式
| 快捷键 | 模式 | 功能 |
|--------|------|------|
| `<C-q>` | n, v | 块选择（替代 `<C-v>`，解决终端冲突） |

### OpenCode 终端缓冲区
在 OpenCode 终端中，以下快捷键已被禁用，防止误操作：
| 快捷键 | 说明 |
|--------|------|
| `<C-c>` | 禁用（防止中断进程） |
| `<C-x>` | 禁用（防止冲突） |
| `<C-z>` | 禁用（防止挂起进程） |

## 编码规范

### 通用规则
- Leader 键：`,`
- Local Leader 键：`\`
- 注释语言：中文
- 缩进：4 空格
- Tab：展开为空格

### 插件配置格式
每个插件配置文件必须返回 lazy.nvim 规范表：

```lua
return {
  'author/plugin-name',
  dependencies = {
    -- 依赖插件列表
  },
  event = 'BufReadPre',  -- 或使用 lazy = false 立即加载
  config = function()
    local plugin = require('plugin-name')
    plugin.setup({
      -- 配置选项
    })
    
    -- 快捷键映射
    vim.keymap.set('n', '<key>', '<cmd>Command<CR>', { desc = '描述' })
  end,
}
```

### 模块导出格式
配置模块使用表导出：

```lua
local M = {}

M.function_name = function()
  -- 实现
end

return M
```

## 用户命令

| 命令 | 功能 |
|------|------|
| `:GenGTags` | 生成 GTAGS 数据库 |
| `:GtagsStatus` | 查看 GTAGS 状态 |
| `:Gtags [args]` | 执行 gtags 搜索 |
| `:DiagnosticsEnable` | 启用诊断显示 |
| `:DiagnosticsDisable` | 禁用诊断显示 |
| `:DiagnosticsToggle` | 切换诊断显示 |
| `:DiagnosticsStatus` | 查看诊断状态 |

## 当前配置状态

### 已启用
- gtags 代码导航（替代 LSP）
- nvim-cmp 补全
- Telescope 搜索
- Tree-sitter 语法高亮
- gitsigns Git 集成
- gruvbox 主题 (hard contrast)
- OpenCode AI 助手

### 已禁用
- LSP（使用 gtags 替代）
- 诊断显示（默认隐藏，命令切换）

### 主题
- 使用 gruvbox，contrast = "hard"

## 新增插件检查清单

添加新插件时，确保：

1. 在 `lua/plugins/` 下创建独立配置文件
2. 在 `lua/plugins/init.lua` 中引入
3. 快捷键不与现有快捷键冲突
4. 注释使用中文
5. 遵循 lazy.nvim 规范格式
6. 如需修改基础设置，更新 `lua/config/basic.lua`

## 禁止事项

- 不要启用 LSP 功能（当前使用 gtags 替代）
- 不要在快捷键中使用 emoji
- 不要使用英文注释
- 不要硬编码 API 密钥
- 不要修改 Leader 键（保持为 `,`）