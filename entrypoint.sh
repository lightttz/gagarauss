#!/bin/bash

# Inicia em background apenas para baixar o binário interno
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
