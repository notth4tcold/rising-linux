#!/bin/bash

# Cria o diretório .config se não existir
mkdir -p .config

# Copia as configurações do usuário
cp -r ~/.config/sway .config/
cp -r ~/.config/wofi .config/
cp -r ~/.config/kitty .config/
cp -r ~/.config/waybar .config/
cp -r ~/.config/eww .config/

echo "Backup das configurações concluído em .config/"