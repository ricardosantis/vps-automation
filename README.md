# VPS Automation - Scripts de Backup, Limpeza e Manutenção para Docker Swarm

Este repositório contém scripts prontos para automatizar tarefas essenciais em um servidor com Docker Swarm e Portainer. Inclui:

- Backup automático das stacks via API do Portainer
- Envio dos backups para repositório privado no GitHub
- Rotação de logs
- Limpeza e compactação de arquivos antigos
- Estrutura organizada com pastas para scripts, logs, envs e backups

---

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






---

## 📚 Requisitos

- Servidor Linux (Ubuntu testado)
- Docker Swarm ativo
- Portainer com agente instalado e acessível via domínio
- Git instalado
- jq instalado: `apt install jq -y`
- curl instalado (geralmente já vem com o sistema)

---

## 🔧 Instalação Passo a Passo

### 1. Clone o repositório

```bash
cd /root
git clone https://github.com/SEU_USUARIO/vps-automation.git
cd vps-automation
```

### 2. Organize a estrutura de pastas

```bash
mkdir -p /root/scripts/{scripts,logs,envs,backups/portainer_stacks}
cp -r scripts/* /root/scripts/scripts/
```

### 3. Crie os arquivos `.env`

#### 3.1 `/root/scripts/envs/.env_portainer`
```env
[ PORTAINER ]
Dominio do portainer: portainer.seudominio.com.br
Usuario: seu_usuario
Senha: sua_senha
```

#### 3.2 `/root/scripts/envs/.env_github`
```env
GITHUB_USUARIO="seu_usuario"
GITHUB_TOKEN="seu_token"
REPO_NOME="portainer-stacks-backup"
```

**Obs:** Gere o token no GitHub em [https://github.com/settings/tokens](https://github.com/settings/tokens) com permissão para repositórios privados.

### 4. Torne os scripts executáveis

```bash
chmod +x /root/scripts/scripts/*.sh
```

### 5. Agende os scripts no crontab

```bash
crontab -e
```

Adicione:

```cron
# Backup das stacks às 2h
0 2 * * * /root/scripts/scripts/backup_stacks_portainer.sh >> /root/scripts/logs/backup_stacks_portainer.log 2>&1

# Envio para o GitHub às 2h30
30 2 * * * /root/scripts/scripts/enviar_backups_github.sh >> /root/scripts/logs/enviar_backups_github.log 2>&1

# Limpeza e compressão de backups antigos às 1h
0 1 * * * /root/scripts/scripts/limpar_backups_antigos.sh >> /root/scripts/logs/limpar_backups_antigos.log 2>&1
```

---

## 🔍 Scripts incluídos

- `backup_stacks_portainer.sh`: Faz backup de todas as stacks existentes via API do Portainer
- `enviar_backups_github.sh`: Envia os arquivos de backup para repositório GitHub
- `limpar_backups_antigos.sh`: Comprime arquivos `.yaml` com mais de 3 dias e remove `.gz` com mais de 14 dias
- `reiniciar-redis.sh`: Reinicia o container do Redis se precisar
- `forcar_limpeza_overlay2_real.sh`: (opcional/desabilitado) remove diretórios antigos do overlay2 (usar com cautela)

---

## 📅 Logs e rotação

Cada script gera um `.log` dentro da pasta `/root/scripts/logs/`.

Recomenda-se usar `logrotate`. Exemplo de arquivo em `/etc/logrotate.d/backup_stacks_portainer`:

```conf
/root/scripts/logs/backup_stacks_portainer.log {
  daily
  rotate 7
  compress
  missingok
  notifempty
  su root root
}
```

---

## 🚧 Observações finais

- Esses scripts foram criados para uso próprio em VPS com Docker Swarm e Portainer
- Use sob sua responsabilidade
- Sempre teste manualmente antes de ativar os agendamentos automáticos

---

Feito com ❤️ por [ricardosantis](https://github.com/ricardosantis)



