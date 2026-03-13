# OpenCode 与 NeoVim 深度集成教程

## 概述
您的 NeoVim 配置已经成功集成了 OpenCode AI 编程助手，通过 DashScope API 访问大语言模型。下面是详细使用说明。

## 重要提示

### 初始配置设置
运行以下命令使 NeoVim 意识到新的 OpenCode 配置：

```bash
# 重新加载环境变量
source ~/.bashrc

# 重启 NeoVim 以应用修改后的插件配置
```

## 通过 NeoVim 使用 OpenCode 的详细步骤

### 1. 通过提问使用 OpenCode (快速代码理解与生成)
- 使用方法：
    1. 移动光标到目标代码位置 
    2. 按 `<C-a>` (Ctrl+A)
    3. 在弹出的输入框中输入指令（例如: `解释这段代码的作用 @this` 或 `@this 重新实现为更高效的版本`）
    4. 按回车确认

### 2. 使用预定义动作
- 使用方法:
    1. 选中目标代码块（使用 visual mode: `v`, `V`, 或 `<C-v>`）
    2. 按 `<C-x>` (Ctrl+X) 
    3. 从列表中选择一个动作（如代码审查、优化、修复问题等）

### 3. 隐藏/显示 OpenCode 界面
- 使用方法：按 `<C-.>` (Ctrl+Period)
- 可以控制 OpenCode 界面的显示/隐藏状态

### 4. 操作符用法 (Operator Mode)
OpenCode 插件实现了操作符功能，可以和其他范围指定符搭配使用：

- `go` 组合键: 
  - `vipgo` -> 选择段落并发送给 OpenCode
  - `a{go` -> 选择花括号块并发送给 OpenCode
  - `2jgo` -> 选择从当前位置开始的3行并发送给 OpenCode
  - `gggoG` -> 选择全文并发送给 OpenCode

- `goo` 组合键（对应于当前行）:
  - `goo` -> 将当前行发送给 OpenCode
  - `5gOO` -> 重复该操作来将多行发送给 OpenCode

### 5. 基于上下文的提示占位符

| 占位符      | 代表内容                  |
| ------------ | --------------------------- |
| @this       | 用户操作的指定上下文区域    |
| @buffer     | 当前缓冲区                |
| @buffers    | 所有打开的缓冲区            |
| @visible    | 当前可见区域的文本          |
| @diagnostics| 当前缓冲区的诊断信息       |
| @quickfix   | quickfix 列表               |
| @diff       | 当前 Git 差异变化           |
| @marks      | 全局标记（如 `mA`)          |
| @grapple    | grapple.nvim 标签（如有）   |

## 在 OpenCode 与 NeoVim 之间切换

切换方式取决于 OpenCode 提供的应用程序接口 (CLI/GUI)，但基本工作流程是:

- 在 **NeoVim** 中，您可以:
    - 按快捷键启动 OpenCode 服务
    - 在编辑器内提问
    - 与生成的代码交互

- 在 **OpenCode** 服务中 (通常运行在浏览器):
    - 查看完整的交互历史
    - 查看长时间运行的请求
    - 可以复制并粘贴代码片段回到 NeoVim

## 常见使用场景

1. **快速问题解答**: 光标置于问题代码处，按 `<C-a>` 输入"这是做什么的?"
2. **性能优化**: 视觉选择代码块，用 `<C-x>` 执行"性能优化"
3. **代码重构**: 选中复杂逻辑区域，用 `<C-a>` 提示"重构为更清晰的函数"
4. **错误修复**: 光标在错误代码旁，按 `<C-a>` 说明错误，然后让 OpenCode 提供修复建议

## 故障排除

如果遇到问题，请尝试下面的步骤：

- 确认已正确设置环境变量: `echo $OPENCODE_API_ENDPOINT` 和 `echo $OPENCODE_API_KEY`
- 检查在 `.bashrc` 中的配置
- 确认 OpenCode CLI/Agent 可用: `opencode --version`

## 自定义设置

如果要更改快捷键，请修改 `~/.config/nvim/lua/plugins/opencode.lua` 文件中相应的 `vim.keymap.set` 函数调用。

现在您已准备好充分利用 OpenCode AI 助手的强大功能增强您的编程体验！
