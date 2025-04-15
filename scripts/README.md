# Scripts de Automação - VPS

Este diretório contém os scripts responsáveis por automações e manutenções do servidor VPS. Abaixo, segue a descrição de cada um:

---

### `backup_stacks_portainer.sh`
Realiza o backup de todas as stacks cadastradas no Portainer via API, salvando os arquivos `.yaml` na pasta de backup definida.

---

### `enviar_backups_github.sh`
Compacta os arquivos de backup das stacks e envia automaticamente para o repositório privado do GitHub.

---

### `forcar_limpeza_overlay2_real.sh`
Remove diretórios órfãos da pasta `/var/lib/docker/overlay2` que não foram modificados nos últimos 10 dias, liberando espaço em disco.

---

### `limpar_backups_antigos.sh`
Compacta os backups com mais de 3 dias e remove os arquivos `.gz` com mais de 14 dias, mantendo o diretório de backups limpo.

---

### `limpeza_docker.sh`
Executa a limpeza de recursos não utilizados do Docker: containers parados, imagens dangling e redes não utilizadas.

---

### `reiniciar-redis.sh`
Reinicia o container do Redis de forma controlada, útil para lidar com problemas de cache ou de travamento do serviço.

---

Todos os scripts geram logs individuais na pasta `/root/scripts/logs/` e estão agendados via `crontab`.

