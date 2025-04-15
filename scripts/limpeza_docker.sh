#!/bin/bash
# Nome: limpeza_docker.sh
# Descrição: Limpa logs antigos e realiza manutenções no Docker
# Agendado via crontab para rodar aos domingos às 3h
# Saída de log: /root/scripts/logs/limpeza_docker.log

# Arquivo de log
LOGFILE="/var/log/limpeza_docker.log"
echo "------------------- $(date '+%Y-%m-%d %H:%M:%S') -------------------" >> "$LOGFILE"

echo "🔍 Limpando logs de containers..." | tee -a "$LOGFILE"
find /var/lib/docker/containers/ -name "*.log" -exec truncate -s 0 {} \; 2>>"$LOGFILE"

echo "🗑️  Limpando imagens não utilizadas..." | tee -a "$LOGFILE"
docker image prune -a -f >> "$LOGFILE" 2>&1

echo "🧹 Limpando volumes não utilizados..." | tee -a "$LOGFILE"
docker volume prune -f >> "$LOGFILE" 2>&1

echo "📦 Removendo revisões antigas do snap (se houver)..." | tee -a "$LOGFILE"
snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do
  snap remove "$snapname" --revision="$revision" >> "$LOGFILE" 2>&1
done

echo "✅ Limpeza finalizada. Uso de disco após limpeza:" | tee -a "$LOGFILE"
df -h | tee -a "$LOGFILE"

echo "" >> "$LOGFILE"
