#!/bin/bash

# Скрипт для встановлення Docker, Docker Compose, Python та Django.
# Призначений для Ubuntu/Debian систем.

set -e

echo "Початок перевірки та встановлення необхідних інструментів..."

# 1. Оновлення пакетів (потрібно для apt)
echo "Оновлення списку пакетів..."
sudo apt-get update -y

# 2. Встановлення Docker
if ! command -v docker &> /dev/null; then
    echo "Docker не знайдено. Встановлюю Docker..."
    sudo apt-get install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Додавання репозиторію
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
    echo "Docker успішно встановлено!"
else
    echo "Docker вже встановлений: $(docker --version)"
fi

# 3. Встановлення Docker Compose
if ! docker compose version &> /dev/null && ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose не знайдено. Встановлюю Docker Compose Plugin..."
    sudo apt-get install -y docker-compose-plugin
    echo "Docker Compose успішно встановлено!"
else
    echo "Docker Compose вже встановлений."
fi

# 4. Встановлення Python (3.9+)
if ! command -v python3 &> /dev/null; then
    echo "Python 3 не знайдено. Встановлюю Python 3..."
    sudo apt-get install -y python3 python3-pip python3-venv
    echo "Python 3 успішно встановлено!"
else
    echo "Python 3 вже встановлений: $(python3 --version)"
fi

# Перевірка наявності pip3
if ! command -v pip3 &> /dev/null; then
    echo "pip3 не знайдено. Встановлюю python3-pip..."
    sudo apt-get install -y python3-pip
fi

# 5. Встановлення Django
if ! python3 -m django --version &> /dev/null; then
    echo "Django не знайдено. Встановлюю Django..."
    pip3 install django
    echo "Django успішно встановлено!"
else
    echo "Django вже встановлений: $(python3 -m django --version)"
fi

echo "Всі необхідні інструменти перевірено та встановлено!"
echo "Для перевірки виконайте: docker --version, docker compose version, python3 --version, django-admin --version"
