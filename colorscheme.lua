return {
  'ellisonleao/gruvbox.nvim', -- 修正为正确的 gruvbox 仓库地址
  name = 'gruvbox',
  priority = 1000,
  lazy = false, -- 确保在启动时加载
  config = function()
    local gruvbox = require('gruvbox')
    gruvbox.setup({
      contrast = "hard",
      overrides = {
        -- 可以在这里自定义高亮组
      }
    })
    vim.cmd.colorscheme('gruvbox')
  end,
}