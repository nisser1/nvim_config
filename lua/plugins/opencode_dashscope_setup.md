# OpenCode 配置 DashScope API 说明

## 环境变量配置

在 ~/.bashrc 中已设置以下环境变量：

```bash
export OPENCODE_API_ENDPOINT="https://dashscope.aliyuncs.com/compatible-mode/v1"
export OPENCODE_API_KEY="YOUR_DASHSCOPE_API_KEY_HERE"  # 请替换为您的真实API密钥
```

## API 端点说明

DashScope 兼容 OpenAI 格式的 API，支持以下端点：

1. `https://dashscope.aliyuncs.com/compatible-mode/v1` - 主要的兼容模式端点
2. `https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions` - 聊天补全端点
3. `https://coding.dashscope.aliyuncs.com/apps/anthropic/v1` - Anthropic 模型端点

## 配置步骤

1. 替换 `YOUR_DASHSCOPE_API_KEY_HERE` 为你的实际 DashScope API 密钥
2. 运行 `source ~/.bashrc` 以加载新配置
3. 重启 NeoVim 以应用新的配置

## 验证配置

启动 NeoVim 并尝试使用 OpenCode 功能，如：
- 按 `<C-a>` 然后输入提示内容
- 检查是否有 API 连接错误

## 注意事项

- DashScope API 采用兼容 OpenAI 的格式，因此适用于大多数遵循 OpenAI 标准的客户端
- DashScope 支持多种大语言模型，包括通义千问等
- 确保网络可以访问 dashscope.aliyuncs.com