return {
  "nvim-treesitter/nvim-treesitter",
  version = "v0.10.0", -- 核心：锁定官方稳定版（与Telescope完全兼容）
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })
  end,
  priority = 1000,
  lazy = false,
  config = function()
    -- 新版 API 是 configs（复数），v0.9.1 版本用这个！
    local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
    if not ok then
      vim.notify("Treesitter 加载失败：" .. ts_configs, vim.log.levels.ERROR)
      return
    end

    ts_configs.setup({
      ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc" }, -- 官方推荐的基础解析器
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })

    -- 验证 v0.9.1 版本中 ft_to_lang 是否存在（必输出 function）
    local parsers_ok, parsers = pcall(require, "nvim-treesitter.parsers")
    if parsers_ok then
      local ft_to_lang_type = type(parsers.ft_to_lang)
      --print("ft_to_lang 函数类型：", ft_to_lang_type) -- v0.9.1 会输出 "function"
      if ft_to_lang_type == "function" then
        --vim.notify("Treesitter v0.9.1 版本兼容成功，ft_to_lang 函数存在", vim.log.levels.INFO)
      end
    end
  end,
}