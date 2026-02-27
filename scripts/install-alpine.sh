#!/bin/bash

echo "=========================================="
echo "TechNova Solutions - Instalação do Site"
echo "=========================================="
echo ""

# Atualizar repositórios
echo "[1/7] Atualizando repositórios..."
apk update

# Instalar Nginx
echo "[2/7] Instalando Nginx..."
apk add nginx

# Criar diretório para logs personalizados
echo "[3/7] Criando diretórios de logs..."
mkdir -p /var/log/nginx/technova

# Criar diretório do site
echo "[4/7] Criando diretório do site..."
mkdir -p /var/www/technova

# Obter diretório do projeto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Copiar arquivos do site
echo "[5/7] Copiando arquivos do site..."
cp -r "$PROJECT_DIR/website"/* /var/www/technova/

# Configurar permissões corretas
echo "[6/7] Configurando permissões..."
chown -R nginx:nginx /var/www/technova
chmod -R 755 /var/www/technova
find /var/www/technova -type f -exec chmod 644 {} \;

# Configurar Nginx
echo "[7/7] Configurando Nginx..."
cp "$PROJECT_DIR/nginx/site.conf" /etc/nginx/http.d/technova.conf

# Ajustar usuário no nginx.conf
sed -i 's/user www-data;/user nginx;/' /etc/nginx/nginx.conf 2>/dev/null || true

# Testar configuração do Nginx
echo ""
echo "Testando configuração do Nginx..."
nginx -t

# Iniciar Nginx
echo "Iniciando Nginx..."
rc-service nginx start
rc-update add nginx default

echo ""
echo "=========================================="
echo "Instalação concluída com sucesso!"
echo "=========================================="
echo ""
echo "Acesse o site em: http://localhost"
echo ""
