#!/bin/bash

set -e

# Make directory for prometheus
sudo rm -fr /var/lib/prometheus/*
sudo mkdir /var/lib/prometheus \
           /var/lib/prometheus/data \
           /var/lib/prometheus/file \
           /var/lib/prometheus/grafana \
           /var/lib/prometheus/configs \
           /var/lib/prometheus/alertmanager \
           /var/lib/prometheus/data/prometheus-ecs-discovery -p \

sudo chmod -R 777 /var/lib/prometheus/data
sudo chmod -R 777 /var/lib/prometheus/grafana
sudo cp ./config/* /var/lib/prometheus/configs
sudo cp ./docker-compose.yml /var/lib/prometheus/

# Download ecs discovery module
wget https://github.com/teralytics/prometheus-ecs-discovery/archive/v1.3.1.zip
unzip v1.3.1.zip
rm -f v1.3.1.zip
sudo mv -f ./prometheus-ecs-* /var/lib/prometheus/file/

# Start Service
cd /var/lib/prometheus
sudo docker-compose up -d
