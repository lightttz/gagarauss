#!/bin/bash

# FORÇA O CONTAINER A PREFERIR IPV6 PARA SAÍDA DE INTERNET
echo "precedence ::ffff:0:0/96  100" >> /etc/gai.conf

# O resto do código continua igual...
./gaga_files/apphub &
APPHUB_PID=$!
# ... (restante do script que já enviamos anteriormente)
