#!/bin/bash

set -e

echo "Starting deployment..."

# Создаем рабочую директорию
sudo mkdir -p /opt
sudo chown $USER:$USER /opt
cd /opt

# Клонируем репозиторий
GIT_REPO="https://github.com/Ervikson/shvirtd-example-python.git"
REPO_NAME="shvirtd-example-python"

if [ -d "$REPO_NAME" ]; then
    echo "Repository already exists, pulling latest changes..."
    cd $REPO_NAME
    git pull origin main
else
    echo "Cloning repository..."
    git clone $GIT_REPO
    cd $REPO_NAME
fi

# Проверяем наличие ompose.yaml
if [ ! -f "compose.yaml" ]; then
    echo "ERROR: compose.yaml not found!"
    echo "Current directory: $(pwd)"
    echo "Files in directory:"
    ls -la
    exit 1
fi

# Останавливаем существующие контейнеры
echo "Stopping existing containers..."
sudo docker compose down || true

# Собираем и запускаем проект
echo "Building and starting services..."
sudo docker compose up --build -d

echo "Deployment completed successfully!"
echo "Service will be available at: http://$(curl -s ifconfig.me):8090"

# Ждем немного для запуска сервисов
sleep 10

# Проверяем статус контейнеров
echo "Container status:"
sudo docker ps