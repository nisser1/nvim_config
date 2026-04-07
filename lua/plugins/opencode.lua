return {
  "nickjvandyke/opencode.nvim",
  dependencies = {
    "hrsh7th/nvim-cmp",  -- 与 cmp 一起工作
    {
      "folke/snacks.nvim",
      opts = {
        input = {}, -- Optimize `ask()` functionality
        picker = {  -- Optimize `select()` functionality
          actions = {
            opencode_send = function(...) 
              return require("opencode").snacks_picker_send(...) 
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
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
          vim.env.OPENCODE_API_KEY = env.ANTHROPIC_AUTH_TOKEN
        end
        if env.ANTHROPIC_BASE_URL then
          local endpoint = env.ANTHROPIC_BASE_URL
          if endpoint:match("/anthropic$") then
            endpoint = endpoint:gsub("/anthropic$", "/v1")
          end
          vim.env.OPENCODE_API_ENDPOINT = endpoint
        end
        if env.ANTHROPIC_MODEL then
          vim.env.OPENCODE_MODEL = env.ANTHROPIC_MODEL
        end
      end
    end
  end,
  config = function()
    -- 设置 opencode.nvim 的配置
    -- 使用全局变量代替 setup() 函数
    vim.g.opencode_opts = vim.g.opencode_opts or {
      -- OpenCode API 配置
      api = {
        endpoint = vim.env.OPENCODE_API_ENDPOINT,
        key = vim.env.OPENCODE_API_KEY,
      },
      -- Window config: 42% of terminal width
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

    vim.o.autoread = true -- 用于 `opts.events.reload`

    -- 优化的键位映射
    -- 更改 <C-.> 为 <C-_>，同时添加更多更易记的组合键
    vim.keymap.set({"n", "x"}, "<C-a>", 
      function() require("opencode").ask("@this: ", { submit = true }) end, 
      { desc = "Ask opencode…" })

    vim.keymap.set({"n", "x"}, "<C-x>", 
      function() require("opencode").select() end,                          
      { desc = "Execute opencode action…" })

    -- 使用 <leader>o 作为 OpenCode 操作的前缀键（更容易记住且不会冲突）
    vim.keymap.set({"n", "t"}, "<F6>",  -- 替代之前冲突的 <C-_>
      function() 
        require("opencode").toggle()
        -- 添加一个延迟以确保窗口创建完成
        vim.defer_fn(function()
          -- 遍历所有窗口，查找 OpenCode 的聊天或输入窗口
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local buf = vim.api.nvim_win_get_buf(win)
            local bufname = vim.api.nvim_buf_get_name(buf)
            local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
            
            -- 尝试匹配 OpenCode 相關窗口，特別尋找輸入區域
            if buftype == 'terminal' or bufname:match('opencode') or bufname:match('chat') then
              vim.api.nvim_set_current_win(win)
              
              -- 在终端窗口中查找输入提示符，如果可用则进入插入模式
              if buftype == 'terminal' then
                vim.cmd('startinsert!')
                -- 在终端模式下添加快捷键用于窗口导航
                vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Go to left window" })
                vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Go to right window" })
                vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Go to bottom window" })
                vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Go to top window" })
              end
              break
            end
          end
        end, 150)
      end,                          
      { desc = "Toggle opencode and focus input" })

    -- 添加额外的快捷键，专门用于跳转到 opencode 输入框（如果已打开）
    vim.keymap.set({"n", "t"}, "<leader><F6>", 
      function()
        -- 遍历所有窗口，查找 OpenCode 输入窗口
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          local bufname = vim.api.nvim_buf_get_name(buf)
          local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
          
             -- 尝试匹配 OpenCode 输入相关窗口
             if bufname:match('opencode') or bufname:match('chat') or buftype == 'terminal' then
               vim.api.nvim_set_current_win(win)
               
               -- 判断窗口类型，如果是终端则进入插入模式
               if buftype == 'terminal' then
                 vim.cmd('startinsert!')
                 -- 在终端模式下添加快捷键用于窗口导航
                 vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Go to left window" })
                 vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Go to right window" })
                 vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Go to bottom window" })
                 vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Go to top window" })
               end
               break
          end
        end
      end,                          
      { desc = "Focus opencode input (if open)" })

    -- 新增: leader+o 作为主菜单快捷键
    vim.keymap.set({"n", "x"}, "<leader>o", 
      function() require("opencode").select() end,                          
      { desc = "Open OpenCode Menu" })

    vim.keymap.set({"n", "x"}, "go",  
      function() return require("opencode").operator("@this ") end,        
      { desc = "Add range to opencode", expr = true })

    vim.keymap.set("n", "goo", 
      function() return require("opencode").operator("@this ") .. "_" end, 
      { desc = "Add line to opencode", expr = true })

    -- 新增: leader+oa 向 openCode 提问
    vim.keymap.set({"n", "x"}, "<leader>oa", 
      function() require("opencode").ask("@this: ", { submit = true }) end, 
      { desc = "Ask OpenCode" })

    -- 新增: leader+ot 临时打开 openCode 交互窗口
    vim.keymap.set({"n", "x"}, "<leader>ot", 
      function() require("opencode").toggle() end,                          
      { desc = "Toggle OpenCode" })
      

    -- 在终端模式下添加快捷键用于窗口导航（全局设置，避免遗漏情况）
    vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Go to left window" })
    vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Go to right window" })
    vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Go to bottom window" })
    vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Go to top window" })

    -- Disable Ctrl+C, Ctrl+X, Ctrl+Z in OpenCode terminal buffer
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