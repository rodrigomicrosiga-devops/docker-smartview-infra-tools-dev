FROM debian:bookworm-slim

# Evita prompts interativos durante a instalação dos pacotes
ENV DEBIAN_FRONTEND=noninteractive

# Instala ferramentas básicas e o cliente nativo do Postgres (psql)
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    apt-transport-https \
    ca-certificates \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Adiciona o repositório oficial da Microsoft e instala o sqlcmd (mssql-tools18)
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg \
    && curl -sSL https://packages.microsoft.com/config/debian/12/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y mssql-tools18 \
    && rm -rf /var/lib/apt/lists/*

# Garante que o sqlcmd esteja disponível no PATH global do container
ENV PATH="$PATH:/opt/mssql-tools18/bin"

# Define o diretório de trabalho padrão dentro do container
WORKDIR /opt/smartview_init