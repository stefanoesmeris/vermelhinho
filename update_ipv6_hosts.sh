#!/bin/bash
# Obtem todos os endereços IPv6 Globais, bem como as interfaces associadas e exporta para o GitHub no formato /etc/hosts
#
REPO_DIR="/srv/github/vermelhinho"
OUTPUT_FILE="$REPO_DIR/ipv6_hosts"

# Gera o arquivo
ip -6 -o addr show scope global | awk '{split($4,addr,"/"); print addr[1], "host-"$2}' > "$OUTPUT_FILE"

cd "$REPO_DIR"

# Verifica se houve mudanças
if ! git diff --quiet; then
    git add "$OUTPUT_FILE"
    git commit -m "Atualização automática de IPv6 hosts em $(date '+%Y-%m-%d %H:%M:%S')"
    git push origin main
fi

