#!/bin/bash
# Nome: forcar_limpeza_overlay2_real.sh
# Descrição: Remove diretórios órfãos do overlay2 não modificados nos últimos 10 dias
# Agendado via crontab para rodar todos os dias às 3h
# Saída de log: /root/scripts/logs/limpeza_overlay2.log

espaco_antes=$(du -s /var/lib/docker/overlay2 | awk '{print $1}')

OVERLAY_PATH="/var/lib/docker/overlay2"

echo "🧹 Limpando pastas não modificadas nos últimos 10 dias em: $OVERLAY_PATH"
echo ""

find "$OVERLAY_PATH" -maxdepth 1 -type d -name '[a-f0-9]*' -mtime +10 | while read dir; do
  SIZE=$(du -sh "$dir" | awk '{print $1}')
  echo "🗑️  Removendo: $(basename "$dir") (Tamanho: $SIZE)"
  rm -rf "$dir"
done

echo ""
echo "✅ Limpeza completa."

espaco_depois=$(du -s /var/lib/docker/overlay2 | awk '{print $1}')
espaco_liberado_kb=$((espaco_antes - espaco_depois))
espaco_liberado_gb=$(echo "scale=2; $espaco_liberado_kb / 1024 / 1024" | bc)

echo ""
echo "📉 Espaço liberado: $espaco_liberado_gb GB"
