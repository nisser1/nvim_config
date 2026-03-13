# Opencode.nvim 配置说明

## 功能描述
Opencode.nvim 是一个将 OpenCode AI 助手与 Neovim 集成的插件，它使您可以直接在编辑器中使用 AI 辅助功能。

## 快捷键映射
- `<C-a>`: 向 AI 提问 (Ask opencode…)
- `<C-x>`: 执行 AI 操作 (Execute opencode action…)
- `<C-.>`: 切换 Opencode 界面 (Toggle opencode)
- `go`: 将选定范围添加到 Opencode (Add range to opencode)
- `goo`: 将当前行添加到 Opencode (Add line to opencode)

## 使用提示
- 使用 `<C-a>` 后可以直接输入问题，AI 会在指定上下文中为您提供答案
- 在可视模式下选择代码块后使用 `<C-a>` 可对选定的代码提问
- 使用 `<C-x>` 可执行预定义的 AI 行动或选择自定义操作
- 使用 `<C-.>` 可以打开或关闭 Opencode 的界面

## 高级用法示例
- 在可视模式下选择一行/一块代码，再按下 <C-a>，可以使用 "@this: " 提示针对选中内容进行讨论
- 使用 go 或 goo 命令可以选择代码范围然后对其进行 AI 动作

要了解更多高级上下文和自定义提示，请查阅 Opencode 文档。