local M = {}

-- 返回合并后的插件列表（移除LSP相关的插件，但启用gtags相关插件）
M.plugins = {
  require("plugins.opencode"),
  require("plugins.treesitter"),
  --require("plugins.lspconfig"),   -- 注释掉LSP配置
  --require("plugins.mason"),       -- 注释掉LSP包管理器
  require("plugins.telescope"),
  require("plugins.cmp"),
  require("plugins.colorscheme"),
  require("plugins.gitsigns"),
  require("plugins.ctags"), -- 启用gtags功能
  require("plugins.aerial"), -- 符号大纲
}

return M