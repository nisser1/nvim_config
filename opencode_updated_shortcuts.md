# OpenCode in NeoVim - 更新的快捷键设置

## 已修复并新增的快捷键

根据之前的 `<C-.>` 无效问题，我们进行了以下调整：

### 旧快捷键 (有问题):
- `<C-.>` (难以输入或在某些终端中不被识别) - 已替换为 `<C-_>`

### 新增和修改的快捷键:

1. **`<C-a>`** (Ctrl+A): 在 Normal 或 Visual 模式下向 OpenCode 发起提问
2. **`<C-x>`** (Ctrl+X): 在 Normal 或 Visual 模式下选择要执行的 OpenCode 操作
3. **`<C-_>`** (Ctrl+Shift+-): 在 Normal 或 Terminal 模式下切换 OpenCode 界面的可见性 (替代不可用的 `<C-.>`)
   - 按住 Control 键同时按 Shift 和连字符键（减号）
4. **`<leader>o`** (Leader 键 + o): 打开 OpenCode 主菜单选择要执行的操作
5. **`<leader>oa`** (Leader 键 + o + a): 直接向 OpenCode 提问
6. **`<leader>ot`** (Leader 键 + o + t): 开启或关闭 OpenCode 交互界面
7. **`go`**: 在 Normal 或 Visual 模式下使用操作符模式将范围发送给 OpenCode
8. **`goo`**: 在 Normal 模式下将当前行发送给 OpenCode

### 操作符模式示例:
- `vipgo` (选择段落并发送给 OpenCode)
- `5jgo` (从当前位置向下5行并发送给 OpenCode)
- `viwgo` (选择单词并发送给 OpenCode)

## 如何使用

### 1. 使用新的 <leader> 快捷键:
- 将光标定位到你想要处理的代码上
- 按 `<leader>oa` 然后输入问题/指令 (默认前缀是 "@this: ")

### 2. 使用 Ctrl 组合键:
- `<C-_>` 用于切换 OpenCode 的交互窗口的可视化状态
- `<leader>ot` 也可完成同样的切换功能，更加易记

## 注意事项

1. 确认 `<leader>` 键 (通常默认为 `\` ) 在你的 NeoVim 中设置正确
2. 如果 `<C-_>` 键不易使用，在 `~/.config/nvim/lua/plugins/opencode.lua` 文件中可将其修改为你更喜欢的组合
3. 所有快捷方式都已更新到新的配置文件中，需要重新启动 NeoVim 才能生效

现在，您可以尝试在 NeoVim 中使用上述任何快捷键来激活 OpenCode 功能。如果仍有问题，请尝试使用 `<leader>` 组合键，这些通常是最可靠的。
