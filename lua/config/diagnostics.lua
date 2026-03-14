-- 诊断配置管理模块
-- 此模块集中管理nvim的诊断显示设置
-- 通过此配置可隐藏或显示LSP诊断标记（如错误E、警告W等）
local M = {}

-- 存储当前诊断配置状态的表
M.current_config = {
  virtual_text = false,
  signs = false,
  underline = false,
  update_in_insert = false
}

---安全获取诊断配置
-- 如果vim.diagnostic.get_config存在则优先使用，否则返回存储的当前配置
local function safe_get_config()
  if vim.diagnostic.get_config then
    return vim.diagnostic.get_config()
  else
    return M.current_config
  end
end

---禁用诊断显示（隐藏E/W等标记）
-- 用途：当不想被大量诊断信息干扰时使用
-- 功能：隐藏侧边栏符号、行内文本和下划线提示
M.disable_diagnostics = function()
  vim.diagnostic.config({
    virtual_text = false,  -- 禁用内联诊断文本（不显示错误/警告文字在行末）
    signs = false,         -- 禁用侧边栏诊断符号（不在Gutter区域显示E/W图标）
    underline = false,     -- 不使用下划线标记错误/警告
    update_in_insert = false,  -- 插入模式时不更新诊断信息
  })
  -- 更新本地存储的配置
  M.current_config.virtual_text = false
  M.current_config.signs = false
  M.current_config.underline = false
  M.current_config.update_in_insert = false
end

---启用诊断显示（显示E/W等标记）
-- 用途：当需要查看代码问题详情时使用
-- 功能：恢复所有诊断提示显示
M.enable_diagnostics = function()
  vim.diagnostic.config({
    virtual_text = true,  -- 启用内联诊断文本显示错误/警告
    signs = true,         -- 启用侧边栏诊断符号（显示E/W图标）
    underline = true,     -- 使用下划线标记错误/警告
    severity_sort = true, -- 按严重性排序诊断
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
    update_in_insert = false,
  })
  -- 更新本地存储的配置
  M.current_config.virtual_text = true
  M.current_config.signs = true
  M.current_config.underline = true
  M.current_config.update_in_insert = false
  
  print("诊断显示已启用：E/W等标记已显示")
end

---获取当前诊断状态
-- 输出当前诊断配置的状态信息
M.get_status = function()
  local config = safe_get_config()
  local status = {}
  status.virtual_text = config.virtual_text
  status.signs = config.signs
  status.underline = config.underline
  
  local diag_enabled = status.virtual_text or status.signs or status.underline
  if diag_enabled then
    print("诊断显示状态：已启用")
    print(string.format("- 虚拟文本: %s", tostring(config.virtual_text)))
    print(string.format("- 符号标记: %s", tostring(config.signs)))
    print(string.format("- 下划线: %s", tostring(config.underline)))
  else
    print("诊断显示状态：已禁用")
  end
end

---切换诊断显示状态
-- 在启用和禁用状态之间切换
M.toggle_diagnostics = function()
  local config = safe_get_config()
  local is_enabled = config.virtual_text or config.signs or config.underline
  if is_enabled then
    M.disable_diagnostics()
  else
    M.enable_diagnostics()
  end
end

-- 启动时默认禁用诊断显示
-- 这样在大型项目（如FFmpeg）中不会显示大量错误和警告标记
M.disable_diagnostics()

-- 提供命令来控制诊断显示
-- 可以在nvim命令模式中使用以下命令：
-- :DiagnosticsEnable  - 启用诊断显示
-- :DiagnosticsDisable - 禁用诊断显示  
-- :DiagnosticsToggle  - 切换诊断显示状态
-- :DiagnosticsStatus  - 查看当前诊断配置状态
vim.api.nvim_create_user_command("DiagnosticsEnable", M.enable_diagnostics, {})
vim.api.nvim_create_user_command("DiagnosticsDisable", M.disable_diagnostics, {})
vim.api.nvim_create_user_command("DiagnosticsToggle", M.toggle_diagnostics, {})
vim.api.nvim_create_user_command("DiagnosticsStatus", M.get_status, {})

return M