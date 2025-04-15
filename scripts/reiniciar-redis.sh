#!/bin/bash
# Nome: reiniciar-redis.sh
# Descrição: Reinicia o serviço Redis via Docker
# Agendado via crontab para rodar diariamente às 4h
# Saída de log: /root/scripts/logs/redis-restart.log

# Reinicia todos os serviços que usam redis:latest
for service in $(docker service ls --format '{{.Name}}' | grep redis); do
  echo "Reiniciando o serviço: $service"
  docker service update --force "$service"
done

# Reinicia todos os serviços que usam n8n
for service in $(docker service ls --format '{{.Name}}' | grep n8n); do
  echo "Reiniciando o serviço: $service"
  docker service update --force "$service"
done

# Reinicia todos os serviços que usam Evolution
for service in $(docker service ls --format '{{.Name}}' | grep evolution); do
  echo "Reiniciando o serviço: $service"
  docker service update --force "$service"
done

# Reinicia todos os serviços que usam Evolution
for service in $(docker service ls --format '{{.Name}}' | grep chatwoot); do
  echo "Reiniciando o serviço: $service"
  docker service update --force "$service"
done
