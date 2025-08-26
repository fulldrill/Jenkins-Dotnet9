FROM jenkins/jenkins:lts

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    apt-transport-https \
    gnupg \
    ca-certificates \
    libicu-dev \
    docker.io \
    docker-compose \
    && rm -rf /var/lib/apt/lists/*

# Install .NET 9 SDK (auto-detect architecture)
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "arm64" ]; then \
        echo "Installing .NET 9 SDK (ARM64)..." && \
        wget https://dotnetcli.azureedge.net/dotnet/Sdk/9.0.100/dotnet-sdk-9.0.100-linux-arm64.tar.gz -O dotnet9.tar.gz; \
    else \
        echo "Installing .NET 9 SDK (AMD64/x64)..." && \
        wget https://dotnetcli.azureedge.net/dotnet/Sdk/9.0.100/dotnet-sdk-9.0.100-linux-x64.tar.gz -O dotnet9.tar.gz; \
    fi && \
    mkdir -p /usr/share/dotnet && \
    tar -xzf dotnet9.tar.gz -C /usr/share/dotnet && \
    ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet && \
    rm dotnet9.tar.gz

# Switch back to Jenkins user
USER jenkins
