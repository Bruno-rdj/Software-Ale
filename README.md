# TF01 - TechNova Solutions

## Aluno
- **Nome:** Bruno Rocha Rozadas de Jesus
- **RA:** 6324038
- **Curso:** Análise e Desenvolvimento de Sistemas

## Empresa Fictícia
- **Nome:** TechNova Solutions
- **Ramo:** Consultoria e Desenvolvimento de Software
- **Descrição:** Empresa especializada em soluções tecnológicas inovadoras, desenvolvimento de software personalizado e consultoria em transformação digital.

## Como Executar

### Pré-requisitos
- Ubuntu 20.04+ ou similar
- Acesso sudo

### Instalação
```bash
# Clone o repositório
git clone https://github.com/Bruno-rdj/Software-Ale.git
cd Software-Ale

# Execute o script de instalação
chmod +x scripts/install.sh
sudo ./scripts/install.sh
```

## Acesso
- **Site principal:** http://localhost
- **Páginas disponíveis:**
  - `/` (Home)
  - `/sobre.html`
  - `/servicos.html`
  - `/contato.html`

## Configurações Aplicadas
- Nginx configurado com virtual host personalizado
- Logs personalizados em `/var/log/nginx/technova/`
- Permissões configuradas para usuário www-data
- Página 404 customizada
- HTML5 semântico e responsivo
- CSS personalizado sem frameworks

## Comandos Úteis
```bash
# Verificar status do Nginx
sudo systemctl status nginx

# Ver logs de acesso
sudo tail -f /var/log/nginx/technova/access.log

# Ver logs de erro
sudo tail -f /var/log/nginx/technova/error.log

# Recarregar configuração do Nginx
sudo nginx -t && sudo systemctl reload nginx
```

## Estrutura do Projeto
```
TF01/
├── README.md
├── website/
│   ├── index.html
│   ├── sobre.html
│   ├── servicos.html
│   ├── contato.html
│   ├── 404.html
│   ├── css/
│   │   └── style.css
│   └── images/
│       └── logo.png
├── nginx/
│   └── site.conf
├── scripts/
│   └── install.sh
└── docs/
    ├── empresa.md
    └── configuracao.md
```

## Tecnologias Utilizadas
- Nginx (Servidor Web)
- HTML5 (Estrutura)
- CSS3 (Estilização)
- Linux (Sistema Operacional)

## Autor
Bruno Rocha Rozadas de Jesus - 6324038
