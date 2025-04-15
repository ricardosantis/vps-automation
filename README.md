# VPS Automation – Scripts de Automação para VPS com Docker Swarm

Este repositório contém um conjunto completo de scripts shell para automatizar tarefas comuns em VPSs com Docker Swarm e Portainer, incluindo backup, limpeza de arquivos órfãos e envio para o GitHub.

---

## 📁 Estrutura de Pastas

/root/scripts
├── backups/
│   └── portainer_stacks/     → Backups das stacks do Portainer (.yaml)
│
├── envs/
│   ├── .env_portainer        → Variáveis com credenciais do Portainer
│   └── .env_github           → Token e config do repositório GitHub
│
├── logs/
│   ├── backup_stacks_portainer.log
│   ├── enviar_backups_github.log
│   ├── limpeza_docker.log
│   ├── limpeza_overlay2.log
│   ├── limpar_backups_antigos.log
│   └── redis-restart.log
│
└── scripts/
    ├── backup_stacks_portainer.sh
    ├── enviar_backups_github.sh
    ├── limpar_backups_antigos.sh
    ├── limpeza_docker.sh
    ├── forcar_limpeza_overlay2_real.sh
    └── reiniciar-redis.sh

---

## 🔧 Funcionalidades

- Backup automático das stacks via API do Portainer
- Envio seguro dos arquivos para repositório privado GitHub
- Limpeza e compactação de backups antigos
- Reinício agendado de serviços como Redis
- Limpeza periódica do Docker e diretórios overlay2
- Estrutura pronta para cron + logrotate

---

## ✅ Requisitos

- VPS com Docker e Docker Swarm configurados
- Portainer com agente e autenticação via API
- Dependências: `curl`, `jq`, `git`, `gzip`, `logrotate`

---

## 🔐 Segurança

As credenciais são mantidas fora do versionamento, em arquivos `.env` como:

**/root/scripts/envs/.env_portainer**
```env
DOMINIO=portainer.seudominio.com
USUARIO=admin
SENHA=suasenha


**/root/scripts/envs/.env_github
```env
GITHUB_USUARIO=seunome
GITHUB_TOKEN=seutoken
REPO_NOME=portainer-stacks-backup

---

## 🖥️ Execução manual

Fazer backup:
/root/scripts/scripts/backup_stacks_portainer.sh

Enviar para GitHub:
/root/scripts/scripts/enviar_backups_github.sh

Limpar backups antigos:
/root/scripts/scripts/limpar_backups_antigos.sh

---

## 📅 Cron (exemplo configurado)

0 2 * * * /root/scripts/scripts/backup_stacks_portainer.sh >> /root/scripts/logs/backup_stacks_portainer.log 2>&1
30 2 * * * /root/scripts/scripts/enviar_backups_github.sh >> /root/scripts/logs/enviar_backups_github.log 2>&1
0 1 * * * /root/scripts/scripts/limpar_backups_antigos.sh >> /root/scripts/logs/limpar_backups_antigos.log 2>&1

---

## 📌 Observações

O script forcar_limpeza_overlay2_real.sh deve ser executado apenas manualmente, pois pode causar falhas em containers se rodado em momentos críticos.

Não é recomendada a modificação manual dos arquivos .yaml no repositório GitHub. Eles são apenas cópias de segurança.

---

## 🤝 Contribuição

Este repositório foi criado para ajudar outros usuários que utilizam o mesmo instalador Docker com Portainer e enfrentam os mesmos desafios. Fique à vontade para sugerir melhorias ou adaptar à sua realidade.

