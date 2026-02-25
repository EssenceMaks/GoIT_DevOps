#!/bin/bash

# Скрипт для встановлення Docker, Docker Compose, Python та Django.
# Призначений для Ubuntu, Debian та Arch Linux.

set -e

echo "Початок перевірки та встановлення необхідних інструментів..."

# Визначення ОС
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Не вдалося визначити операційну систему."
    exit 1
fi

# 1. Оновлення пакетів
if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    echo "Виявлено Ubuntu/Debian. Оновлення списку пакетів..."
    sudo apt-get update -y
elif [[ "$OS" == "arch" || "$OS" == "manjaro" ]]; then
    echo "Виявлено Arch Linux. Оновлення бази пакетів..."
    sudo pacman -Sy --noconfirm
else
    echo "Ця операційна система ($OS) не підтримується цим скриптом."
    exit 1
fi

# 2. Встановлення Docker
if ! command -v docker &> /dev/null; then
    echo "Docker не знайдено. Встановлюю Docker..."
    if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
        sudo apt-get install -y ca-certificates curl gnupg
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/$OS/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
        sudo chmod a+r /etc/apt/keyrings/docker.asc

        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/$OS \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
          
        sudo apt-get update -y
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
    elif [[ "$OS" == "arch" || "$OS" == "manjaro" ]]; then
        sudo pacman -S --noconfirm docker
        sudo systemctl enable --now docker
    fi
    echo "Docker успішно встановлено!"
else
    echo "Docker вже встановлений: $(docker --version)"
fi

# 3. Встановлення Docker Compose
if ! docker compose version &> /dev/null && ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose не знайдено. Встановлюю Docker Compose..."
    if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
        sudo apt-get install -y docker-compose-plugin
    elif [[ "$OS" == "arch" || "$OS" == "manjaro" ]]; then
        sudo pacman -S --noconfirm docker-compose
    fi
    echo "Docker Compose успішно встановлено!"
else
    echo "Docker Compose вже встановлений."
fi

# 4. Встановлення Python (3.9+)
if ! command -v python3 &> /dev/null; then
    echo "Python 3 не знайдено. Встановлюю Python 3..."
    if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
        sudo apt-get install -y python3 python3-pip python3-venv
    elif [[ "$OS" == "arch" || "$OS" == "manjaro" ]]; then
        sudo pacman -S --noconfirm python python-pip python-virtualenv
    fi
    echo "Python 3 успішно встановлено!"
else
    echo "Python 3 вже встановлений: $(python3 --version)"
fi

# Перевірка наявності pip
PIP_CMD="pip3"
if [[ "$OS" == "arch" || "$OS" == "manjaro" ]]; then
    PIP_CMD="pip"
fi

if ! command -v $PIP_CMD &> /dev/null; then
    echo "$PIP_CMD не знайдено. Встановлюю..."
    if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
        sudo apt-get install -y python3-pip
    elif [[ "$OS" == "arch" || "$OS" == "manjaro" ]]; then
        sudo pacman -S --noconfirm python-pip
    fi
fi

# 5. Встановлення Django
if ! python3 -m django --version &> /dev/null; then
    echo "Django не знайдено. Встановлюю Django..."
    if [[ "$OS" == "arch" || "$OS" == "manjaro" ]]; then
        # На Arch Linux встановлюємо через системний пакет або pip з прапорцем
        sudo pacman -S --noconfirm python-django || $PIP_CMD install --break-system-packages django
    else
        $PIP_CMD install django
    fi
    echo "Django успішно встановлено!"
else
    echo "Django вже встановлений: $(python3 -m django --version)"
fi

echo "Всі необхідні інструменти перевірено та встановлено!"
echo "Для перевірки виконайте: docker --version, docker compose version, python3 --version, django-admin --version"
