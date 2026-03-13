-- Basic configuration settings for Neovim
-- This file will contain basic vim configurations converted to Neovim Lua format

-- Number column settings
vim.opt.number = true              -- Show absolute line numbers
vim.opt.relativenumber = false     -- Don't show relative line numbers (standard number display)

-- Advanced number column settings
vim.opt.numberwidth = 4            -- Set number column width (default is 4) 
vim.opt.signcolumn = "yes"         -- Always show sign column to prevent shifting

-- Basic editor settings from .vimrc  
vim.opt.hlsearch = true            -- Highlight search results
vim.opt.wrap = false               -- Don't wrap lines
vim.opt.cursorline = true          -- Highlight current cursor line
vim.opt.cursorcolumn = false       -- Don't highlight cursor column (only line)
vim.opt.showmatch = true           -- Highlight matching brackets

-- Improve cursor visibility during navigation
vim.opt.cursorlineopt = "number,line"  -- Only highlight line number and line when in normal mode

vim.opt.ignorecase = true          -- Case insensitive search...
vim.opt.smartcase = true           -- ...but case sensitive if uppercase letters are used
vim.opt.incsearch = true           -- Incremental search
vim.opt.autoread = true            -- Automatically read file changes if file modified outside of Neovim
vim.opt.hidden = true              -- Allow unsaved buffers to remain open (e.g. when switching files)

-- Color and display settings
vim.opt.syntax = "enable"  -- Enable syntax highlighting
vim.opt.background = "dark"  -- Set background to dark  
vim.opt.termguicolors = true  -- Enable true color support (modern replacement for t_Co)

-- Enhanced cursor visibility
vim.opt.cursorline = false  -- Disabled since it's not effective enough for your needs

-- Indentation settings
vim.opt.tabstop = 4       -- Number of spaces that a tab counts for
vim.opt.softtabstop = 4   -- Number of spaces that a tab counts for when editing
vim.opt.expandtab = true  -- Expand tabs to spaces
vim.opt.shiftwidth = 4    -- Number of spaces to use for each step of (auto)indent
vim.opt.list = true       -- Show whitespace characters
vim.opt.listchars = {tab = '▸ ', space = '·'}  -- Characters to show for whitespace

local M = {}

return M