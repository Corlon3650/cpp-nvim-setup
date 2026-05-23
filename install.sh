#!/bin/bash

# Цвета для красивого вывода
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Установка Neovim окружения для C++ ===${NC}"

# Определяем директорию, где лежит сам скрипт
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Обновление пакетов
echo -e "${GREEN}[1/8] Обновление пакетов...${NC}"
pkg update && pkg upgrade -y

# 2. Запрос на права доступа
echo -e "${GREEN}[2/8] Запрос доступа к хранилищу...${NC}"
termux-setup-storage

# 3. Установка nodejs
echo -e "${GREEN}[3/8] Установка Node.js...${NC}"
pkg install nodejs -y

# 4. Установка neovim
echo -e "${GREEN}[4/8] Установка Neovim...${NC}"
pkg install neovim -y

# 5. Установка clang (компилятор C++)
echo -e "${GREEN}[5/8] Установка Clang...${NC}"
pkg install clang -y

# 6. Создание папок конфигурации
echo -e "${GREEN}[6/8] Создание папок конфигурации...${NC}"
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim/lua/plugins
# 8. Копирование cpp.lua
echo -e "${GREEN}[7/8] Копирование cpp.lua...${NC}"
if [ -f "$SCRIPT_DIR/cpp.lua" ]; then
    cp "$SCRIPT_DIR/cpp.lua" ~/.config/nvim/lua/plugins/cpp.lua
    echo -e "${GREEN}cpp.lua скопирован${NC}"
else
    echo -e "${RED}Ошибка: файл cpp.lua не найден в $SCRIPT_DIR${NC}"
    exit 1
fi

# 9. Копирование init.lua
echo -e "${GREEN}[8/8] Копирование init.lua...${NC}"
if [ -f "$SCRIPT_DIR/init.lua" ]; then
    cp "$SCRIPT_DIR/init.lua" ~/.config/nvim/init.lua
    echo -e "${GREEN}init.lua скопирован${NC}"
else
    echo -e "${RED}Ошибка: файл init.lua не найден в $SCRIPT_DIR${NC}"
    exit 1
fi

# Запуск neovim
echo -e "${GREEN}=== Установка завершена! Запускаем Neovim... ===${NC}"
nvim