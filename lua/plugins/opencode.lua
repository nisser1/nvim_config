return {
  "nickjvandyke/opencode.nvim",
  lazy = true,
  cmd = { "OpenCode" },
  keys = {
    { "<C-a>", mode = { "n", "x" }, function() require("opencode").ask("@this: ", { submit = true }) end, desc = "Ask opencode…" },
    { "<C-x>", mode = { "n", "x" }, function() require("opencode").select() end, desc = "Execute opencode action…" },
    { "<F6>", mode = { "n", "t" }, function() require("opencode").toggle() end, desc = "Toggle opencode" },
    { "<leader><F6>", mode = { "n", "t" }, function()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local bufname = vim.api.nvim_buf_get_name(buf)
        local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
        if bufname:match('opencode') or bufname:match('chat') or buftype == 'terminal' then
          vim.api.nvim_set_current_win(win)
          if buftype == 'terminal' then vim.cmd('startinsert!') end
          break
        end
      end
    end, desc = "Focus opencode input (if open)" },
    { "<leader>o", mode = { "n", "x" }, function() require("opencode").select() end, desc = "Open OpenCode Menu" },
    { "go", mode = { "n", "x" }, function() return require("opencode").operator("@this ") end, desc = "Add range to opencode", expr = true },
    { "goo", mode = "n", function() return require("opencode").operator("@this ") .. "_" end, desc = "Add line to opencode", expr = true },
    { "<leader>oa", mode = { "n", "x" }, function() require("opencode").ask("@this: ", { submit = true }) end, desc = "Ask OpenCode" },
    { "<leader>ot", mode = { "n", "x" }, function() require("opencode").toggle() end, desc = "Toggle OpenCode" },
  },
  dependencies = {
    "hrsh7th/nvim-cmp",
    {
      "folke/snacks.nvim",
      opts = {
        input = {},
        picker = {
          actions = {
            opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
          },
          win = {
            input = {
              keys = { ["<a-a>"] = { "opencode_send", mode = { "n", "i" } } },
            },
          },
        },
      },
    },
  },
  config = function()
    vim.g.opencode_opts = vim.g.opencode_opts or {
      events = { enabled = true, reload = false },
      server = {
        toggle = function()
          require("opencode.terminal").toggle("opencode --port", {
            relative = "editor",
            width = math.floor(vim.o.columns * 0.42),
            height = vim.o.lines - 2,
            row = 0,
            col = math.floor(vim.o.columns * 0.58),
          })
        end,
      },
    }

    vim.o.autoread = true

    vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Go to left window" })
    vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Go to right window" })
    vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Go to bottom window" })
    vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Go to top window" })

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*opencode*",
      callback = function(event)
        local opts = { buffer = event.buf, silent = true }
        vim.keymap.set("t", "<C-c>", "<Nop>", opts)
        vim.keymap.set("t", "<C-x>", "<Nop>", opts)
        vim.keymap.set("t", "<C-z>", "<Nop>", opts)
      end,
    })
  end
}