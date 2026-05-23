-- ============================================
--  Единый конфиг Neovim для C++ на Termux
-- ============================================

-- 1. Установка менеджера плагинов lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Список плагинов
require("lazy").setup({
  -- LSP-клиент
  { "neovim/nvim-lspconfig" },

  -- Автодополнение
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = { { name = "nvim_lsp" } }
      })
    end
  },

  -- Автоподстановка скобок и кавычек
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end
  },
})

-- 3. Настройка языкового сервера clangd
vim.lsp.config.clangd = {
  cmd = { "clangd" },
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
}
vim.lsp.enable("clangd")

-- 4. Базовые настройки интерфейса
vim.opt.number = true          -- Нумерация строк
vim.opt.tabstop = 4            -- Размер табуляции
vim.opt.shiftwidth = 4         -- Размер отступа
vim.opt.expandtab = true       -- Табы пробелами

-- 5. Функция компиляции и запуска C++ кода
function RunCpp()
  vim.cmd("write")                      -- сохранить файл
  local file = vim.fn.expand("%:p")     -- полный путь к файлу
  local name = vim.fn.expand("%:t:r")   -- имя без расширения

  vim.cmd("cd ~")                       -- перейти в домашнюю папку

  -- Закрыть старые окна терминала
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
      vim.api.nvim_win_close(win, false)
    end
  end

  -- Открыть новый терминал справа и выполнить компиляцию/запуск/удаление
  vim.cmd("vert botright new")
  vim.cmd("terminal clang++ -std=c++17 " .. file .. " -o " .. name .. " && ./" .. name .. " && rm -f " .. name)
end

-- 6. Горячие клавиши
vim.keymap.set({ "n", "i" }, "<C-b>", RunCpp, { desc = "Compile and run C++" })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n>', { desc = "Exit terminal mode" })
