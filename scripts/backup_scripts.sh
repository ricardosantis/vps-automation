#!/bin/bash

DATA=$(date '+%Y-%m-%d_%H-%M')
ARQUIVO="/root/scripts/backups/backup_scripts_${DATA}.tar.gz"

echo "📦 Gerando backup completo da pasta /root/scripts"
tar -czf "$ARQUIVO" --exclude='backups/*.tar.gz' --exclude='logs/*.log' /root/scripts

echo "✅ Backup salvo em: $ARQUIVO"
