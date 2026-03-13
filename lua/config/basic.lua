-- Basic configuration settings for Neovim
-- This file will contain basic vim configurations converted to Neovim Lua format

local M = {}

-- Initialize the basic configuration
M.setup = function()
  -- Number column settings
  vim.opt.number = true              -- Show absolute line numbers
  vim.opt.relativenumber = false     -- Don't show relative line numbers (standard number display)

  -- Advanced number column settings
  vim.opt.numberwidth = 4            -- Set number column width (default is 4) 
  vim.opt.signcolumn = "yes"         -- Always show sign column to prevent shifting

  -- Basic editor settings from .vimrc
  vim.opt.hlsearch = true            -- Highlight search results
  vim.opt.wrap = false               -- Don't wrap lines
  
  -- Color and display settings
  vim.opt.syntax = "enable"  -- Enable syntax highlighting
  vim.g.gruvbox_contrast_dark = "hard"  -- Set gruvbox theme contrast
  vim.opt.background = "dark"  -- Set background to dark
  vim.opt.t_Co = 256  -- Enable 256 color mode
  
  -- Indentation settings
  vim.opt.tabstop = 4       -- Number of spaces that a tab counts for
  vim.opt.softtabstop = 4   -- Number of spaces that a tab counts for when editing
  vim.opt.expandtab = true  -- Expand tabs to spaces
  vim.opt.shiftwidth = 4    -- Number of spaces to use for each step of (auto)indent
  vim.opt.list = true       -- Show whitespace characters
  vim.opt.listchars = {tab = '▸ ', space = '·'}  -- Characters to show for whitespace
end

return M