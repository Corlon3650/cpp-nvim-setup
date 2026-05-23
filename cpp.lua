-- ~/.config/nvim/lua/plugins/cpp.lua
return {
  -- 1. Плагин для базовых LSP-настроек
  { "neovim/nvim-lspconfig" },

  -- 2. Плагин для автодополнения и его зависимости
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
  },

  -- 3. Тут же, рядом, настраиваем clangd для C++
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config.clangd = {
        cmd = {
          "clangd",
          "--query-driver=/data/data/com.termux/files/usr/bin/g++",
        },
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      }
      vim.lsp.enable("clangd")
    end,
  },

  -- 4. Настройка самого меню автодополнения
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        sources = {
          { name = 'nvim_lsp' }
        }
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    ivent = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end
  },
}
