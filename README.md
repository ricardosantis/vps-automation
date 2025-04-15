# Automacoes para VPS com Docker Swarm e Portainer

Este repositório reúne uma coleção de scripts shell para auxiliar na manutenção de uma VPS que roda vários containers em ambiente Docker Swarm, com gerenciamento via Portainer.

## Objetivo

O objetivo é manter o servidor limpo, organizado e com backups automatizados das configurações essenciais, evitando perda de dados e acércio desnecessário de recursos como disco e memória RAM.

---

## Estrutura de Diretórios

Os scripts, logs, arquivos `.env` e backups foram organizados da seguinte forma:

```
/root/scripts
├── backups                # Backups gerados automaticamente
│   └── portainer_stacks  # Backups das stacks do Portainer
├── envs                   # Arquivos .env com variáveis e senhas
│   ├── .env_portainer
│   └── .env_github
├── logs                   # Logs das execuções programadas (cron)
├── scripts                # Scripts shell utilizados
│   ├── backup_stacks_portainer.sh
│   ├── enviar_backups_github.sh
│   ├── limpar_backups_antigos.sh
│   ├── reiniciar-redis.sh
│   ├── limpeza_docker.sh
│   └── forcar_limpeza_overlay2_real.sh (desabilitado por padrão)
└── README.md              # (este arquivo)
```

---

## Funcionalidades

| Script                            | Descrição                                                                       |
| --------------------------------- | ------------------------------------------------------------------------------- |
| `backup_stacks_portainer.sh`      | Autentica via API e faz backup das stacks em YAML                               |
| `enviar_backups_github.sh`        | Envia os arquivos de backup para repositório GitHub privado                     |
| `limpar_backups_antigos.sh`       | Compacta YAMLs com +3 dias e remove GZ com +14 dias                             |
| `reiniciar-redis.sh`              | Reinicia o container Redis diariamente (evita vazamento de memória)             |
| `limpeza_docker.sh`               | Limpa imagens não usadas, redes orfãs e containers parados                      |
| `forcar_limpeza_overlay2_real.sh` | Limpa diretórios do overlay2 não modificados nos últimos 10 dias (com cuidado!) |

---

## Cron agendado

```cron
# Reinicia o Redis às 4h e salva o log
0 4 * * * /root/scripts/scripts/reiniciar-redis.sh >> /root/scripts/logs/redis-restart.log 2>&1

# Limpa o Docker aos domingos às 3h
0 3 * * 0 /root/scripts/scripts/limpeza_docker.sh >> /root/scripts/logs/limpeza_docker.log 2>&1

# Backup das stacks do Portainer às 2h
0 2 * * * /root/scripts/scripts/backup_stacks_portainer.sh >> /root/scripts/logs/backup_stacks_portainer.log 2>&1

# Envio dos backups para GitHub às 2h30
30 2 * * * /root/scripts/scripts/enviar_backups_github.sh >> /root/scripts/logs/enviar_backups_github.log 2>&1

# Limpeza de backups antigos às 1h
0 1 * * * /root/scripts/scripts/limpar_backups_antigos.sh >> /root/scripts/logs/limpar_backups_antigos.log 2>&1
```

---

## Requisitos

- Docker Swarm habilitado
- Portainer com agente instalado
- `jq`, `curl`, `gzip`, `git`, `cron`
- Token de acesso pessoal do GitHub com permissão para repositórios privados

---

## Observações

- A limpeza do overlay2 está **desativada por padrão** no cron, pois requer avaliação manual
- O repositório do GitHub é considerado apenas como destino de **backup**, nunca deve ser editado diretamente

---

## Licença

MIT

