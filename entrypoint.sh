#!/bin/bash

# FORÇA O CONTAINER A PREFERIR IPV6 PARA SAÍDA DE INTERNET
echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf

# O resto do código continua igual...
./gaga_files/apphub &
APPHUB_PID=$!

echo "--- Preparando GagaNode... ---"
MAX_RETRIES=30
COUNT=0
while [ $COUNT -lt $MAX_RETRIES ]; do
    GAGA_PATH=$(find . -type f -name gaganode | head -n 1)
    if [ -n "$GAGA_PATH" ]; then
        echo "✅ Binário encontrado!"
        break
    fi
    sleep 5
    COUNT=$((COUNT + 1))
done

if [ -n "$GAGA_PATH" ]; then
    chmod +x "$GAGA_PATH"
    "$GAGA_PATH" config set --token=$GAGA_TOKEN
    echo "Token $GAGA_TOKEN configurado."
    kill $APPHUB_PID
    sleep 2
    # Inicia o supervisor que manterá APENAS o gaganode rodando
    exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
else
    echo "❌ Erro: Falha ao baixar binário."
    exit 1
fi
