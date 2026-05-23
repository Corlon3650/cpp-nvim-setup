-- 1. Подключаем менеджер плагинов (как и было)
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

-- 2. Указываем список плагинов
require("lazy").setup({
  -- Плагин для LSP
  { "neovim/nvim-lspconfig" },
  -- Плагин для автодополнения и его зависимости
  { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp" } },
})

-- 3. ТЕПЕРЬ, после загрузки плагинов, можно их настраивать
-- Настройка LSP для C++ (современный способ через vim.lsp)
vim.lsp.config.clangd = {
  cmd = { "clangd" },
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
}
vim.lsp.enable("clangd")

-- 4. Настройка автодополнения
local cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'nvim_lsp' }
  }
})

-- 5. Базовые визуальные настройки
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true


-- Функция компиляции и запуска
function RunCpp()
  vim.cmd("write")
  
  local file = vim.fn.expand("%:p")
  local name = vim.fn.expand("%:t:r")
  
  vim.cmd("cd ~")
  
  -- Закрываем окно терминала, если оно уже есть
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
      vim.api.nvim_win_close(win, false)
    end
  end
  
  -- Открываем новый терминал и выполняем команду
  vim.cmd("vert botright new")
  vim.cmd("terminal clang++ -std=c++17  " .. file .. " -o " .. name .. " && ./" .. name .. " && rm -f " .. name)
end

-- Привязываем Ctrl+B
vim.keymap.set({ "n", "i" }, "<C-b>", RunCpp, { desc = "Compile and run C++" })
