#!/bin/bash
# Script para baixar seu  local server com os dados remotos do Github.
# URL do arquivo remoto
REMOTE_URL="https://raw.githubusercontent.com/stefanoesmeris/vermelhinho/master/ipv6_hosts"
LOCAL_HOSTS="/etc/hosts"
TMP_FILE="/tmp/ipv6_hosts"

# Baixa o arquivo remoto
curl -s -o "$TMP_FILE" "$REMOTE_URL"

# Para cada linha do arquivo remoto
while IFS= read -r line; do
    # Ignora linhas em branco ou comentários
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Extrai o hostname (última coluna da linha)
    hostname=$(echo "$line" | awk '{print $NF}')

    # Verifica se já existe no /etc/hosts
    if grep -q "[[:space:]]$hostname\$" "$LOCAL_HOSTS"; then
        # Substitui a linha existente pela linha remota
        sudo sed -i "s/.*[[:space:]]$hostname\$/$line/" "$LOCAL_HOSTS"
    else
        # Adiciona a linha ao final do arquivo
        echo "$line" | sudo tee -a "$LOCAL_HOSTS" > /dev/null
    fi
done < "$TMP_FILE"

echo "Sincronização concluída com sucesso!"

