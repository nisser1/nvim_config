# NeoVim 中的 OpenCode 快捷键使用指南

## 快捷键映射

### 主要操作
- `<C-a>` (Ctrl+A): 在 Normal 或 Visual 模式下，向 OpenCode 发起提问
- `<C-x>` (Ctrl+X): 在 Normal 或 Visual 模式下，选择要执行的 OpenCode 操作
- `<C-.>` (Ctrl+.) : 在 Normal 或 Terminal 模式下，切换 OpenCode 界面的可见性

### 操作符模式
- `go` (Normal 或 Visual 模式): 选择范围发送给 OpenCode (类似于操作符 `d`, `y`, `c`)
- `goo` (Normal 模式): 选择整行发送给 OpenCode (类似于 `dd`, `yy`, `cc`)

## 使用场景示例

### 1. 在光标位置使用 OpenCode
- 将光标置于需要处理的代码行上
- 按 `<C-a>`，会提示输入问题/指令，可以使用 `@this: 请优化这段代码` 这样的提示
- 输入完毕后回车执行

### 2. 在选中代码后使用 OpenCode
- 使用 Visual 模式选中一段代码 (`v`/`V`/`<C-v>`)
- 按 `<C-a>`，此时可以基于选中的内容提问
- 或者按 `<C-x>` 执行特定的 AI 操作

### 3. 切换 OpenCode 界面
- 按 `<C-.>` 可以切换 OpenCode 面板的显示/隐藏

### 4. 将任意范围发送给 OpenCode
- 使用命令如：`vipgo` (选择当前段落并发送给 OpenCode)
- 或者 `5jgo` (从当前位置向下5行并发送给 OpenCode)
- `goo` 会自动选择当前行并发送给 OpenCode

## 注意事项

1. 确保 OpenCode 服务正在运行 (`opencode` 命令可用)
2. DashScope API 端点和密钥已在 ~/.bashrc 中配置
3. 如果无法连接，检查终端是否加载了环境变量：`echo $OPENCODE_API_KEY`

## 后续配置

您可以根据需要修改快捷键以适应您的习惯：

1. 在 `lua/plugins/opencode.lua` 中找到 `vim.keymap.set` 行
2. 修改按键组合
3. 重启 Neovim 使更改生效

## 故障排除

如果你收到 API 连接错误:
1. 运行 `source ~/.bashrc` 重新加载环境变量
2. 确认 OpenCode 服务是否正在运行
3. 检查 `~/.bashrc` 中的 API 密钥配置是否正确