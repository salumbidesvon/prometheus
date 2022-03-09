#!/bin/bash

set -e
echo "############### Package Installation #####################"

sudo apt update \
    && apt install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    gawk \
    jq \
    unzip \
    sed \
    software-properties-common \
    default-jre \
    wget \
    && sudo rm -rf /var/lib/apt/lists/*


{ #DOCKER
    echo "##### Installing Docker..." &&
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable" && \
    sudo apt-get update -y && \
    sudo apt-get install -y docker-ce && \
    echo "##### Installed Docker."
} || {
    echo "##### BUILD ERROR: Failed to install Docker."
    exit 1
}

{ #Docker-Compose
    echo "##### Installing Docker-Compose..." && \
    sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    sudo chmod +x /usr/local/bin/docker-compose && \
    docker-compose --version && \
    echo "##### Installed Docker-Compose."
} || {
    echo "##### BUILD ERROR: Failed to install Docker-Compose."
    exit 1
}

echo "########## Manual Package Installation Phase Complete."

echo "########## Starting Service ##################"
sudo usermod -aG docker $(whoami)
sudo usermod -aG docker ubuntu
sudo systemctl enable docker
sudo systemctl start docker
