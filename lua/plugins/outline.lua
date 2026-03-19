return {
  "hedyhli/outline.nvim",
  dependencies = {
    "epheien/outline-treesitter-provider.nvim",
  },
  event = "BufReadPre",
  config = function()
    require("outline").setup({
      outline_window = {
        position = "left",
        split_command = "belowright 15split",
        focus_on_open = true,
        show_numbers = true,
        show_relative_numbers = true,
        auto_close = true,
        auto_jump = false,
      },
      outline_items = {
        show_symbol_details = true,
        show_symbol_lineno = true,
        highlight_hovered_item = true,
      },
      symbol_folding = {
        autofold_depth = 1,
      },
      providers = {
        priority = { "lsp", "treesitter", "markdown" },
      },
      keymaps = {
        goto_location = "<CR>",
        peek_location = "o",
        close = { "<Esc>", "q" },
        fold = "h",
        unfold = "l",
        fold_toggle = "<Tab>",
      },
    })

    vim.keymap.set("n", "<F2>", "<cmd>Outline<CR>", { desc = "Toggle outline" })
    vim.keymap.set("n", "<leader>a", "<cmd>Outline<CR>", { desc = "Toggle outline" })
  end,
}