#!/bin/bash

# Carrega as variáveis do .env com as credenciais do GitHub
source /root/scripts/envs/.env_github

REPO_LOCAL="/tmp/portainer_restore"
REPO_GIT="https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$GITHUB_USER/$GITHUB_REPO.git"

# Clonar o repositório mais recente
echo "🧲 Clonando repositório: $GITHUB_REPO"
rm -rf "$REPO_LOCAL"
git clone "$REPO_GIT" "$REPO_LOCAL"

# Verifica se o repositório foi clonado corretamente
if [ ! -d "$REPO_LOCAL" ]; then
  echo "❌ Falha ao clonar o repositório!"
  exit 1
fi

# Fazer deploy de cada stack
cd "$REPO_LOCAL"
for stack in *.yaml; do
  nome_stack=$(basename "$stack" .yaml)
  echo "🚀 Restaurando stack: $nome_stack"
  docker stack deploy -c "$stack" "$nome_stack"
  sleep 10
done

echo ""
echo "✅ Todas as stacks foram restauradas a partir do GitHub."
