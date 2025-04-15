#!/bin/bash
# Nome: backup_stacks_portainer.sh
# Descrição: Faz backup das stacks existentes no Portainer via API e salva os arquivos .yaml
# Agendado via crontab para rodar diariamente às 2h
# Saída de log: /root/scripts/logs/backup_stacks_portainer.log

# Caminho para o arquivo com os dados
ARQUIVO_DADOS="/root/scripts/envs/.env_portainer"

# Extrair dados do arquivo
DOMINIO=$(grep -i "Dominio do portainer" "$ARQUIVO_DADOS" | awk -F: '{print $2}' | xargs)
USUARIO=$(grep -i "Usuario" "$ARQUIVO_DADOS" | awk -F: '{print $2}' | xargs)
SENHA=$(grep -i "Senha" "$ARQUIVO_DADOS" | awk -F: '{print $2}' | xargs)

echo "🔐 Autenticando no Portainer em: $DOMINIO"

# Gerar novo token
TOKEN=$(curl -s -X POST "https://$DOMINIO/api/auth" \
  -H "Content-Type: application/json" \
  -d "{\"Username\": \"$USUARIO\", \"Password\": \"$SENHA\"}" | jq -r .jwt)

# Verifica se o token foi obtido
if [[ "$TOKEN" == "null" || -z "$TOKEN" ]]; then
  echo "❌ Erro ao autenticar. Verifique suas credenciais."
  exit 1
fi

# Pasta de backup
BACKUP_DIR="/root/scripts/backups/portainer_stacks"
mkdir -p "$BACKUP_DIR"

# Obter todas as stacks
curl -s -H "Authorization: Bearer $TOKEN" "https://$DOMINIO/api/stacks" | jq -c '.[]' | while read -r stack; do
  ID=$(echo "$stack" | jq -r '.Id')
  NAME=$(echo "$stack" | jq -r '.Name')

  echo "📦 Fazendo backup da stack: $NAME (ID: $ID)"

  curl -s -H "Authorization: Bearer $TOKEN" \
    "https://$DOMINIO/api/stacks/$ID/file" > "$BACKUP_DIR/${NAME}.yaml"
done

echo ""
echo "✅ Backups finalizados em: $BACKUP_DIR"
