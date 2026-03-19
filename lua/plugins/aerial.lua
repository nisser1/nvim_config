return {
  "stevearc/aerial.nvim",
  event = "BufReadPre",
  config = function()
    require("aerial").setup({
      -- 在底部显示
      layout = {
        default_direction = "prefer_bot",
        placement = "edge",
        width = 40,
        min_width = 20,
      },
      -- 使用 treesitter 作为后端（因为 LSP 已禁用）
      backends = { "treesitter", "lsp", "markdown" },
      -- 显示指南线
      show_guides = true,
      -- 自动打开
      open_automatic = false,
      -- 快捷键
      keymaps = {
        ["<CR>"] = "actions.jump",
        ["<C-v>"] = "actions.jump_vsplit",
        ["<C-s>"] = "actions.jump_split",
        ["p"] = "actions.scroll",
        ["<C-j>"] = "actions.down_and_scroll",
        ["<C-k>"] = "actions.up_and_scroll",
        ["{"] = "actions.prev",
        ["}"] = "actions.next",
        ["[["] = "actions.prev_up",
        ["]]"] = "actions.next_up",
        ["q"] = "actions.close",
        ["o"] = "actions.tree_toggle",
        ["za"] = "actions.tree_toggle",
        ["O"] = "actions.tree_toggle_recursive",
        ["zA"] = "actions.tree_toggle_recursive",
        ["l"] = "actions.tree_open",
        ["zo"] = "actions.tree_open",
        ["L"] = "actions.tree_open_recursive",
        ["zO"] = "actions.tree_open_recursive",
        ["h"] = "actions.tree_close",
        ["zc"] = "actions.tree_close",
        ["H"] = "actions.tree_close_recursive",
        ["zC"] = "actions.tree_close_recursive",
        ["zr"] = "actions.tree_increase_fold_level",
        ["zR"] = "actions.tree_open_all",
        ["zm"] = "actions.tree_decrease_fold_level",
        ["zM"] = "actions.tree_close_all",
        ["zx"] = "actions.tree_sync_folds",
        ["zX"] = "actions.tree_sync_folds",
      },
    })

    -- 快捷键绑定
    vim.keymap.set("n", "<F2>", "<cmd>AerialToggle!<CR>", { desc = "Toggle aerial (symbols outline)" })
    vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle aerial" })
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { desc = "Previous symbol" })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { desc = "Next symbol" })
  end,
}