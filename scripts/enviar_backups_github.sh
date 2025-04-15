#!/bin/bash
# Nome: enviar_backups_github.sh
# Descrição: Envia os arquivos de backup das stacks do Portainer para um repositório privado no GitHub
# Agendado via crontab para rodar diariamente às 2h30
# Saída de log: /root/scripts/logs/enviar_backups_github.log

set -e

# Carregar variáveis do .env
source /root/scripts/envs/.env_github

DATA=$(date +%Y-%m-%d_%H-%M)
PASTA_BACKUP="/root/scripts/backups/portainer_stacks"
PASTA_TEMP="/tmp/backup_portainer_$DATA"

echo "📦 Criando pacote temporário: $PASTA_TEMP"
mkdir -p "$PASTA_TEMP"
cp "$PASTA_BACKUP"/*.yaml "$PASTA_TEMP/"

cd "$PASTA_TEMP"
git init
git config user.name "$GITHUB_USUARIO"
git config user.email "$GITHUB_USUARIO@users.noreply.github.com"

echo "📁 Repositório Git inicializado"

git add .
git commit -m "Backup das stacks do Portainer - $DATA"

REPO_URL="https://${GITHUB_USUARIO}:${GITHUB_TOKEN}@github.com/${GITHUB_USUARIO}/${REPO_NOME}.git"

echo "☁️ Enviando para repositório remoto privado: $REPO_NOME"
git branch -M main
git remote add origin "$REPO_URL"

# Força o push sobrescrevendo tudo no GitHub
git push -u origin main --force

echo "✅ Backup enviado com sucesso!"

# Limpa diretório temporário
rm -rf "$PASTA_TEMP"
echo "🧹 Diretório temporário $PASTA_TEMP removido."
