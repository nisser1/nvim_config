local M = {}

-- 返回合并后的插件列表（移除LSP相关的插件）
M.plugins = {
  require("plugins.opencode"),
  require("plugins.treesitter"),
  --require("plugins.lspconfig"),   -- 注释掉LSP配置
  --require("plugins.mason"),       -- 注释掉LSP包管理器
  require("plugins.telescope"),
  require("plugins.cmp"),
  require("plugins.colorscheme"),
  require("plugins.gitsigns"),
  --require("plugins.ctags"), -- 注释掉 ctags/gtags 功能
}

return M