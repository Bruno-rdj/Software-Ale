#!/bin/bash

# Script de instalação do TechNova Solutions Website
# Autor: Bruno Rocha Rozadas de Jesus
# Data: 2024

set -e

echo "=========================================="
echo "TechNova Solutions - Instalação do Site"
echo "=========================================="
echo ""

# Verificar se está rodando como root
if [ "$EUID" -ne 0 ]; then 
    echo "Por favor, execute como root (use sudo)"
    exit 1
fi

# Atualizar repositórios
echo "[1/7] Atualizando repositórios..."
apt-get update -qq

# Instalar Nginx
echo "[2/7] Instalando Nginx..."
apt-get install -y nginx

# Criar diretório para logs personalizados
echo "[3/7] Criando diretórios de logs..."
mkdir -p /var/log/nginx/technova

# Criar diretório do site
echo "[4/7] Criando diretório do site..."
mkdir -p /var/www/technova

# Copiar arquivos do site
echo "[5/7] Copiando arquivos do site..."
cp -r ../website/* /var/www/technova/

# Configurar permissões corretas
echo "[6/7] Configurando permissões..."
chown -R www-data:www-data /var/www/technova
chmod -R 755 /var/www/technova
find /var/www/technova -type f -exec chmod 644 {} \;

# Configurar Nginx
echo "[7/7] Configurando Nginx..."
cp ../nginx/site.conf /etc/nginx/sites-available/technova
ln -sf /etc/nginx/sites-available/technova /etc/nginx/sites-enabled/technova

# Remover configuração padrão se existir
if [ -f /etc/nginx/sites-enabled/default ]; then
    rm /etc/nginx/sites-enabled/default
fi

# Testar configuração do Nginx
echo ""
echo "Testando configuração do Nginx..."
nginx -t

# Habilitar Nginx para iniciar no boot
echo "Habilitando Nginx no boot..."
systemctl enable nginx

# Reiniciar Nginx
echo "Reiniciando Nginx..."
systemctl restart nginx

echo ""
echo "=========================================="
echo "Instalação concluída com sucesso!"
echo "=========================================="
echo ""
echo "Acesse o site em: http://localhost"
echo ""
echo "Comandos úteis:"
echo "  - Status: sudo systemctl status nginx"
echo "  - Logs de acesso: sudo tail -f /var/log/nginx/technova/access.log"
echo "  - Logs de erro: sudo tail -f /var/log/nginx/technova/error.log"
echo ""
