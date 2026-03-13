# Opencode 配置示例

Opencode 需要连接到一个 OpenCode 实例以便工作。您可以通过以下方式进行配置：

## API 设置

在您的 shell 配置文件中（如 ~/.bashrc 或 ~/.zshrc）设置：

export OPENCODE_API_ENDPOINT="https://your-opencode-instance.example.com"
export OPENCODE_API_KEY="your-api-key-here"

## 检查安装

安装 OpenCode CLI 工具以获得最佳体验：

# 简单安装
curl -fsSL https://opencode.ai/install | bash

# 或使用 npm
npm install -g opencode-ai

更多信息请参见 OpenCode 官方网站: https://opencode.ai