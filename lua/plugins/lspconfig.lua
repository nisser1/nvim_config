return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
  config = function()
    -- 初始化 Mason
    require('mason').setup()
    require('mason-lspconfig').setup {
      ensure_installed = { 'clangd'},
    }

    local on_attach = function(client, bufnr)
      local opts = { buffer = bufnr, noremap = true, silent = true }

      -- 常用 LSP 快捷键
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

      -- Telescope 集成
      vim.keymap.set('n', '<C-d>', ':Telescope lsp_definitions<CR>', opts)
      vim.keymap.set('n', '<C-r>', ':Telescope lsp_references<CR>', opts)
      vim.keymap.set('n', '<C-i>', ':Telescope lsp_implementations<CR>', opts)
      vim.keymap.set('n', '<C-t>', ':Telescope lsp_type_definitions<CR>', opts)
      vim.keymap.set('n', '<C-s>', ':Telescope lsp_document_symbols<CR>', opts)
    end

    vim.lsp.start {
      name = 'clangd',
      cmd = { 'clangd', '--background-index', '--clang-tidy' },
      on_attach = on_attach,
      settings = {
        clangd = {
          completion = { detailed = true },
          diagnostics = { enable = true },
          semanticHighlighting = true,
        },
      },
    }

    -- 如果你还用到了 tsserver，也请更新为 ts_ls
    -- vim.lsp.start {
    --   name = 'ts_ls',
    --   on_attach = on_attach,
    --   root_dir = vim.fn.getcwd(),
    -- }
  end,
}