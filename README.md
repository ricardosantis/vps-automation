# VPS Automation – Scripts de Backup e Manutenção com Docker + Portainer

Este repositório contém um conjunto de scripts Shell para automatizar tarefas de manutenção, backup das stacks do Portainer, limpeza de containers Docker e envio dos backups para o GitHub. Tudo centralizado numa estrutura organizada de pastas para facilitar o gerenciamento da sua VPS.

## Estrutura de Pastas

/root/scripts
├── backups/               # Armazena os backups, exemplo: portainer_stacks/
├── envs/                  # Contém os arquivos .env com credenciais
├── logs/                  # Logs dos scripts executados via cron
├── scripts/               # Todos os scripts .sh ficam aqui
├── README.md              # Este arquivo de documentação

## Scripts Disponíveis

backup_stacks_portainer.sh      – Faz backup das stacks do Portainer via API e salva como .yaml
enviar_backups_github.sh        – Envia os backups para repositório privado no GitHub
limpar_backups_antigos.sh       – Compacta arquivos .yaml com +3 dias e remove .gz com +14 dias
reiniciar-redis.sh              – Reinicia o container do Redis (usado como cache)
limpeza_docker.sh               – Remove volumes, imagens e networks não utilizados
forcar_limpeza_overlay2_real.sh – ⚠️ (DESATIVADO) Remove diretórios órfãos do overlay2

## Arquivos .env

Esses arquivos ficam em /root/scripts/envs/

.env_portainer
Dominio do portainer: portainer.seudominio.com.br
Usuario: seu_usuario
Senha: sua_senha

.env_github
GITHUB_USUARIO="seu_usuario"
GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxx"
REPO_NOME="portainer-stacks-backup"

## Agendamentos no Crontab (use crontab -e)

0 4 * * * /root/scripts/scripts/reiniciar-redis.sh >> /root/scripts/logs/redis-restart.log 2>&1
0 3 * * 0 /root/scripts/scripts/limpeza_docker.sh >> /root/scripts/logs/limpeza_docker.log 2>&1
0 2 * * * /root/scripts/scripts/backup_stacks_portainer.sh >> /root/scripts/logs/backup_stacks_portainer.log 2>&1
30 2 * * * /root/scripts/scripts/enviar_backups_github.sh >> /root/scripts/logs/enviar_backups_github.log 2>&1
0 1 * * * /root/scripts/scripts/limpar_backups_antigos.sh >> /root/scripts/logs/limpar_backups_antigos.log 2>&1

## Cuidados

- Nunca edite as stacks direto no GitHub. Ele serve apenas como backup.
- O script forcar_limpeza_overlay2_real.sh está desabilitado por segurança, pois pode apagar dados em uso.
- Para restaurar manualmente, basta importar o .yaml pelo painel do Portainer.

## Repositório

https://github.com/ricardosantis/vps-automation

## Contribuições

Sugestões e melhorias são bem-vindas!
