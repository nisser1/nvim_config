local M = {}

-- 返回合并后的插件列表
M.plugins = {
  require("plugins.opencode"),
  require("plugins.treesitter"),
  require("plugins.lspconfig"),
  require("plugins.mason"),
  require("plugins.telescope"),
  require("plugins.cmp"),
  require("plugins.colorscheme"),
  require("plugins.gitsigns"),
  require("plugins.ctags"),
}

return M