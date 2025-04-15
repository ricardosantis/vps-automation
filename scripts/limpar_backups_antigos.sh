#!/bin/bash
# Nome: limpar_backups_antigos.sh
# Descrição: Compacta backups .yaml com mais de 3 dias e remove os .gz com mais de 14 dias
# Agendado via crontab para rodar diariamente às 1h
# Saída de log: /root/scripts/logs/limpar_backups_antigos.log

# Caminho da pasta de backups
PASTA_BACKUPS="/root/scripts/backups/portainer_stacks"

echo "🔍 Compactando backups com mais de 3 dias..."
find "$PASTA_BACKUPS" -type f -iname "*.yaml" -mtime +3 ! -iname "*.gz" -exec gzip {} \;

echo "🧹 Removendo arquivos compactados com mais de 14 dias..."
find "$PASTA_BACKUPS" -type f -iname "*.gz" -mtime +14 -exec rm -f {} \;

echo "✅ Limpeza e compactação concluídas."
