FROM ubuntu:22.04

# Instalar apenas dependências essenciais
RUN apt-get update && apt-get install -y \
    curl tar wget procps ca-certificates supervisor \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Baixar o AppHub Pro oficial
RUN wget -O gaga.tar.gz https://assets.coreservice.io/public/package/60/app-market-gaga-pro/1.0.4/app-market-gaga-pro-1_0_4.tar.gz \
    && tar -zxf gaga.tar.gz \
    && mv apphub-linux-amd64 gaga_files \
    && rm gaga.tar.gz

COPY entrypoint.sh .
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod +x entrypoint.sh

# Inicia o configurador e depois o supervisor
CMD ["./entrypoint.sh"]
