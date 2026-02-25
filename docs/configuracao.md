# Documentação Técnica - Configuração do Servidor

## Visão Geral

Este documento descreve todas as configurações técnicas aplicadas ao servidor web Nginx para o site da TechNova Solutions, incluindo aspectos de segurança, permissões e boas práticas.

---

## Requisitos do Sistema

### Sistema Operacional
- Ubuntu 20.04 LTS ou superior
- Debian 10 ou superior
- Outras distribuições Linux compatíveis

### Software Necessário
- Nginx 1.18 ou superior
- Git (para clonar o repositório)
- Acesso sudo/root

---

## Estrutura de Diretórios

```
/var/www/technova/          # Diretório raiz do site
├── index.html              # Página principal
├── sobre.html              # Página sobre a empresa
├── servicos.html           # Página de serviços
├── contato.html            # Página de contato
├── 404.html                # Página de erro personalizada
├── css/
│   └── style.css           # Folha de estilos
└── images/
    └── logo.png            # Logo da empresa

/etc/nginx/
├── sites-available/
│   └── technova            # Configuração do site
└── sites-enabled/
    └── technova            # Link simbólico

/var/log/nginx/technova/    # Logs personalizados
├── access.log              # Log de acessos
└── error.log               # Log de erros
```

---

## Configuração do Nginx

### Arquivo de Configuração
Localização: `/etc/nginx/sites-available/technova`

### Principais Configurações

#### 1. Servidor Virtual
```nginx
listen 80;
listen [::]:80;
server_name localhost;
```
- Escuta na porta 80 (HTTP)
- Suporte para IPv4 e IPv6
- Configurado para localhost

#### 2. Diretório Raiz
```nginx
root /var/www/technova;
index index.html;
```
- Define o diretório raiz do site
- Define index.html como página padrão

#### 3. Logs Personalizados
```nginx
access_log /var/log/nginx/technova/access.log;
error_log /var/log/nginx/technova/error.log;
```
- Logs separados para melhor organização
- Facilita troubleshooting e análise

#### 4. Página de Erro 404
```nginx
error_page 404 /404.html;
location = /404.html {
    internal;
}
```
- Página de erro personalizada
- Diretiva `internal` impede acesso direto

#### 5. Cache de Arquivos Estáticos
```nginx
location ~* \.(css|js|jpg|jpeg|png|gif|ico|svg|woff|woff2|ttf|eot)$ {
    expires 30d;
    add_header Cache-Control "public, immutable";
}
```
- Cache de 30 dias para arquivos estáticos
- Melhora performance e reduz carga do servidor

---

## Configurações de Segurança

### 1. Permissões de Arquivos

#### Diretórios
```bash
chmod 755 /var/www/technova
```
- Proprietário: leitura, escrita, execução (7)
- Grupo: leitura, execução (5)
- Outros: leitura, execução (5)

#### Arquivos
```bash
chmod 644 /var/www/technova/*.html
chmod 644 /var/www/technova/css/*.css
```
- Proprietário: leitura, escrita (6)
- Grupo: leitura (4)
- Outros: leitura (4)

#### Proprietário
```bash
chown -R www-data:www-data /var/www/technova
```
- Proprietário: www-data (usuário do Nginx)
- Grupo: www-data
- Recursivo para todos os arquivos e subdiretórios

### 2. Headers de Segurança

#### X-Frame-Options
```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
```
- Previne ataques de clickjacking
- Permite iframe apenas do mesmo domínio

#### X-Content-Type-Options
```nginx
add_header X-Content-Type-Options "nosniff" always;
```
- Previne MIME type sniffing
- Força o navegador a respeitar o Content-Type

#### X-XSS-Protection
```nginx
add_header X-XSS-Protection "1; mode=block" always;
```
- Ativa proteção contra XSS no navegador
- Bloqueia a página se detectar ataque

### 3. Proteção de Arquivos Ocultos
```nginx
location ~ /\. {
    deny all;
    access_log off;
    log_not_found off;
}
```
- Bloqueia acesso a arquivos que começam com ponto
- Protege arquivos como .git, .env, .htaccess

### 4. Desabilitar Listagem de Diretórios
```nginx
autoindex off;
```
- Impede listagem de conteúdo de diretórios
- Previne exposição de estrutura de arquivos

### 5. Ocultar Versão do Nginx
```nginx
server_tokens off;
```
- Não exibe versão do Nginx nos headers
- Dificulta ataques direcionados a versões específicas

---

## Processo de Instalação

### 1. Preparação
```bash
cd TF01/scripts
chmod +x install.sh
```

### 2. Execução
```bash
sudo ./install.sh
```

### 3. Etapas do Script
1. Atualização de repositórios
2. Instalação do Nginx
3. Criação de diretórios de logs
4. Criação do diretório do site
5. Cópia dos arquivos
6. Configuração de permissões
7. Configuração do Nginx

### 4. Verificação
```bash
sudo systemctl status nginx
curl http://localhost
```

---

## Comandos Úteis

### Gerenciamento do Nginx
```bash
# Verificar status
sudo systemctl status nginx

# Iniciar
sudo systemctl start nginx

# Parar
sudo systemctl stop nginx

# Reiniciar
sudo systemctl restart nginx

# Recarregar configuração
sudo systemctl reload nginx

# Testar configuração
sudo nginx -t
```

### Visualização de Logs
```bash
# Logs de acesso em tempo real
sudo tail -f /var/log/nginx/technova/access.log

# Logs de erro em tempo real
sudo tail -f /var/log/nginx/technova/error.log

# Últimas 50 linhas do log de acesso
sudo tail -n 50 /var/log/nginx/technova/access.log

# Buscar erros específicos
sudo grep "error" /var/log/nginx/technova/error.log
```

### Verificação de Permissões
```bash
# Verificar permissões do diretório
ls -la /var/www/technova

# Verificar proprietário
stat /var/www/technova

# Verificar permissões recursivamente
find /var/www/technova -ls
```

---

## Troubleshooting

### Problema: Nginx não inicia
**Solução:**
```bash
# Verificar erros de configuração
sudo nginx -t

# Verificar logs de erro
sudo journalctl -u nginx -n 50
```

### Problema: Página não carrega
**Solução:**
```bash
# Verificar se Nginx está rodando
sudo systemctl status nginx

# Verificar permissões
ls -la /var/www/technova

# Verificar logs
sudo tail -f /var/log/nginx/technova/error.log
```

### Problema: Erro 403 Forbidden
**Solução:**
```bash
# Corrigir permissões
sudo chown -R www-data:www-data /var/www/technova
sudo chmod -R 755 /var/www/technova
sudo find /var/www/technova -type f -exec chmod 644 {} \;
```

### Problema: Página 404 não aparece
**Solução:**
```bash
# Verificar se arquivo existe
ls -la /var/www/technova/404.html

# Verificar configuração do Nginx
sudo nginx -t

# Recarregar configuração
sudo systemctl reload nginx
```

---

## Boas Práticas Aplicadas

### 1. Separação de Logs
- Logs específicos por site facilitam análise e troubleshooting

### 2. Permissões Mínimas
- Princípio do menor privilégio aplicado
- Apenas permissões necessárias são concedidas

### 3. Headers de Segurança
- Múltiplas camadas de proteção contra ataques comuns

### 4. Cache Inteligente
- Melhora performance sem comprometer atualização de conteúdo

### 5. Página de Erro Personalizada
- Melhor experiência do usuário
- Mantém identidade visual da empresa

### 6. Configuração Modular
- Arquivo de configuração separado por site
- Facilita manutenção e escalabilidade

---

## Melhorias Futuras

### 1. HTTPS/SSL
```bash
# Instalar Certbot
sudo apt-get install certbot python3-certbot-nginx

# Obter certificado
sudo certbot --nginx -d seudominio.com
```

### 2. Compressão Gzip
```nginx
gzip on;
gzip_types text/css application/javascript;
```

### 3. Rate Limiting
```nginx
limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
```

### 4. Firewall
```bash
sudo ufw allow 'Nginx Full'
sudo ufw enable
```

---

## Referências

- [Documentação Oficial do Nginx](https://nginx.org/en/docs/)
- [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/)
- [OWASP Security Headers](https://owasp.org/www-project-secure-headers/)

---

*Documento criado em 2024 - TechNova Solutions*
*Última atualização: 2024*
