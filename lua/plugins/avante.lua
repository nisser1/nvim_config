return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  build = "make",
  init = function()
    local db_path = vim.fn.expand("~/.cc-switch/cc-switch.db")
    local settings_path = vim.fn.expand("~/.cc-switch/settings.json")
    
    local handle = io.popen(string.format(
      'python3 -c "import sqlite3,json; s=json.load(open(\'%s\')); cid=s.get(\'currentProviderClaude\',\'\'); c=sqlite3.connect(\'%s\'); r=c.execute(\'SELECT settings_config FROM providers WHERE id=?\',(cid,)).fetchone(); print(r[0] if r else \'{}\')"',
      settings_path, db_path
    ))
    
    if handle then
      local output = handle:read("*a")
      handle:close()
      if output and output ~= "" then
        local decoded = vim.json.decode(vim.trim(output))
        local env = decoded.env or {}
        if env.ANTHROPIC_AUTH_TOKEN then
          vim.env.ANTHROPIC_API_KEY = env.ANTHROPIC_AUTH_TOKEN
        end
        if env.ANTHROPIC_BASE_URL then
          vim.env.ANTHROPIC_BASE_URL = env.ANTHROPIC_BASE_URL
        end
      end
    end
  end,
  opts = {
    provider = "claude",
    providers = {
      claude = {
        endpoint = vim.env.ANTHROPIC_BASE_URL or "https://api.anthropic.com",
        model = "MiniMax-M2.7",
      },
    },
    behaviour = {
      auto_suggestions = false,
    },
    input = {
      provider = "snacks",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-tree/nvim-web-devicons",
    "folke/snacks.nvim",
  },
  config = function(_, opts)
    require("avante").setup(opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", function() require("avante.api").ask() end, { desc = "Avante Ask" })
    vim.keymap.set("n", "<leader>ce", function() require("avante.api").edit() end, { desc = "Avante Edit" })
    vim.keymap.set("n", "<leader>cr", function() require("avante.api").refresh() end, { desc = "Avante Refresh" })
  end,
}