мета — реалізувати повний CI/CD-процес із використанням Jenkins + Helm + Terraform + Argo CD, який:

1. Автоматично збирає Docker-образ для Django-застосунку;

2. Публікує образ в Amazon ECR;

3. Оновлює Helm chart у репозиторії з правильним тегом;

4. Синхронізує застосунок у кластері через Argo CD, який підхоплює зміни з Git.



Кроки виконання завдання

1. Jenkins + Helm + Terraform

Встановіть Jenkins через Helm, автоматизувавши встановлення через Terraform.
Забезпечте роботу Jenkins через Kubernetes Agent (Kaniko + Git).
Реалізуйте pipeline (через Jenkinsfile), який:
Збирає образ із Dockerfile;
Пушить його до ECR;
Оновлює тег у values.yaml іншого репозиторію;
Пушить зміни в main.
2. Argo CD + Helm + Terraform

Встановіть Argo CD через Helm із використанням Terraform.
Налаштуйте Argo CD Application, який стежить за оновленням Helm-чарта.
Argo CD має автоматично синхронізувати зміни у кластері після оновлення Git.

Progect/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB
├── outputs.tf               # Загальні виводи ресурсів
│
├── modules/                 # Каталог з усіма модулями
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   │   ├── s3.tf            # Створення S3-бакета
│   │   ├── dynamodb.tf      # Створення DynamoDB
│   │   ├── variables.tf     # Змінні для S3
│   │   └── outputs.tf       # Виведення інформації про S3 та DynamoDB
│   │
│   ├── vpc/                 # Модуль для VPC
│   │   ├── vpc.tf           # Створення VPC, підмереж, Internet Gateway
│   │   ├── routes.tf        # Налаштування маршрутизації
│   │   ├── variables.tf     # Змінні для VPC
│   │   └── outputs.tf  
│   ├── ecr/                 # Модуль для ECR
│   │   ├── ecr.tf           # Створення ECR репозиторію
│   │   ├── variables.tf     # Змінні для ECR
│   │   └── outputs.tf       # Виведення URL репозиторію
│   │
│   ├── eks/                      # Модуль для Kubernetes кластера
│   │   ├── eks.tf                # Створення кластера
│   │   ├── aws_ebs_csi_driver.tf # Встановлення плагіну csi drive
│   │   ├── variables.tf     # Змінні для EKS
│   │   └── outputs.tf       # Виведення інформації про кластер
│   │
│   ├── jenkins/             # Модуль для Helm-установки Jenkins
│   │   ├── jenkins.tf       # Helm release для Jenkins
│   │   ├── variables.tf     # Змінні (ресурси, креденшели, values)
│   │   ├── providers.tf     # Оголошення провайдерів
│   │   ├── values.yaml      # Конфігурація jenkins
│   │   └── outputs.tf       # Виводи (URL, пароль адміністратора)
│   │ 
│   └── argo_cd/             # ✅ Новий модуль для Helm-установки Argo CD
│       ├── jenkins.tf       # Helm release для Jenkins
│       ├── variables.tf     # Змінні (версія чарта, namespace, repo URL тощо)
│       ├── providers.tf     # Kubernetes+Helm.  переносимо з модуля jenkins
│       ├── values.yaml      # Кастомна конфігурація Argo CD
│       ├── outputs.tf       # Виводи (hostname, initial admin password)
│		    └──charts/                  # Helm-чарт для створення app'ів
│ 	 	    ├── Chart.yaml
│	  	    ├── values.yaml          # Список applications, repositories
│			    └── templates/
│		        ├── application.yaml
│		        └── repository.yaml
├── charts/
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── Chart.yaml
│       └── values.yaml     # ConfigMap зі змінними середовища




Критерії оцінювання (100 балів)



Компонент	Бал
Встановлення Jenkins + Terraform + Helm	20
Робочий Jenkins pipeline, що збирає, пушить і оновлює Git	30
Встановлення Argo CD + Terraform + Helm	20
Argo application із повною синхронізацією Helm chart	20
README.md з описом, командами та схемою CI/CD	10


