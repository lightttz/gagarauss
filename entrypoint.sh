#!/bin/bash

# 1. Teste inicial de IPv6 (para garantir que a rede está OK)
echo "--- Testando conexão IPv6... ---"
if curl -6 -s https://google.com > /dev/null; then
    echo "✅ IPv6 funcionando!"
else
    echo "❌ Erro: IPv6 não alcançável. Verifique o ndppd."
    exit 1
fi

# 2. Iniciar AppHub para baixar o binário
./gaga_files/apphub &
APPHUB_PID=$!

echo "--- Aguardando binário... ---"
MAX_RETRIES=30
COUNT=0
while [ $COUNT -lt $MAX_RETRIES ]; do
    GAGA_PATH=$(find . -type f -name gaganode | head -n 1)
    if [ -n "$GAGA_PATH" ]; then
        echo "✅ Binário gaganode detectado!"
        break
    fi
    sleep 5
    COUNT=$((COUNT + 1))
done

# 3. Configura Token e Mata o IPv4
if [ -n "$GAGA_PATH" ]; then
    chmod +x "$GAGA_PATH"
    "$GAGA_PATH" config set --token=$GAGA_TOKEN
    
    echo "--- Cortando rota IPv4 para forçar IPv6... ---"
    # Remove o gateway IPv4 padrão de dentro do container
    ip route del default
    
    echo "Token injetado. Iniciando via IPv6..."
    kill $APPHUB_PID
    sleep 2
    exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
else
    echo "❌ Erro: O binário não apareceu."
    exit 1
fi
