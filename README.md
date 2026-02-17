# Final Project: CI/CD з Jenkins + Argo CD + Terraform + Helm

Повний CI/CD pipeline для Django застосунку з автоматичним білдом, деплоєм та синхронізацією через GitOps.

## ⚠️ AWS Configuration

**Цей проєкт налаштовано на region `eu-central-1`**

- **EKS Nodes**: 3× `t3.small`
- **RDS Instance**: `db.t3.micro` (PostgreSQL 16.6)
- **Monitoring**: Prometheus + Grafana

## 🎯 Що реалізовано

### Інфраструктура (Terraform)

- **S3 + DynamoDB**: Backend для Terraform state
- **VPC**: Публічні та приватні підмережі
- **ECR**: Docker registry для образів
- **EKS**: Kubernetes кластер з EBS CSI Driver
- **RDS**: PostgreSQL база даних
- **Jenkins**: CI сервер (Helm)
- **Argo CD**: GitOps CD інструмент (Helm)
- **Prometheus + Grafana**: Моніторинг

### CI/CD Pipeline

1. **Jenkins** збирає Docker образ
2. **Jenkins** пушить образ до ECR
3. **Jenkins** оновлює тег в Helm chart
4. **Argo CD** автоматично виявляє зміни в Git
5. **Argo CD** синхронізує новий образ в Kubernetes

## 📁 Структура проєкту

```
goit-devops-fp/
├── main.tf                      # Головний Terraform файл
├── backend.tf                   # S3 backend конфігурація
├── outputs.tf                   # Outputs всіх модулів
├── variables.tf                 # Змінні проєкту
├── secrets.tfvars               # Секретні змінні (паролі)
├── Django/                      # Django застосунок + Jenkinsfile
│   ├── Dockerfile
│   └── Jenkinsfile
├── modules/                     # Terraform модулі
│   ├── s3-backend/
│   ├── vpc/
│   ├── ecr/
│   ├── eks/
│   ├── rds/
│   ├── jenkins/
│   ├── argo_cd/
│   └── monitoring/
└── charts/                      # Helm charts
    └── django-app/
```

## 🚀 Інструкція запуску

### 1. Налаштування GitHub Репозиторіїв

Для повноцінної роботи CI/CD (щоб Jenkins та ArgoCD не були пустими) потрібно створити **2 репозиторії** на GitHub:

1.  **Application Repo** (код застосунку):
    *   Залийте вміст папки `Django/`
    *   Додайте `Jenkinsfile` в корінь цього репозиторію.
2.  **Helm Repo** (конфігурація деплою):
    *   Залийте вміст папки `charts/`

### 2. Налаштування змінних

Оновіть файли конфігурації посиланнями на ваші репозиторії:

*   **Jenkinsfile** (`Django/Jenkinsfile`): Вкажіть правильний ECR registry URL.
*   **ArgoCD Values** (`modules/argo_cd/charts/values.yaml`): Вкажіть `repoURL` на ваш Helm Repo.

### 3. Розгортання інфраструктури (PowerShell)

```powershell
cd goit-devops-fp

# 1. Ініціалізація та створення бекенду (якщо вперше)
# terraform init
# terraform apply -target=module.s3_backend -var-file="secrets.tfvars"
# (Потім розкоментуйте backend.tf)

# 2. Розгортання всього
terraform init -migrate-state
terraform apply -var-file="secrets.tfvars"
```

### 4. Доступ до сервісів

Після розгортання виконайте Port-Forwarding у **різних терміналах**:

**Jenkins:**
```powershell
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
# URL: http://localhost:8080
# Login: admin
# Password: (з secrets.tfvars)
```

**Argo CD:**
```powershell
kubectl port-forward svc/argo-cd-argocd-server 8081:443 -n argocd
# URL: https://localhost:8081
# Login: admin
# Password: Отримайте командою нижче
```
*Отримати пароль ArgoCD:*
```powershell
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | % { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
```

**Grafana:**
```powershell
kubectl port-forward svc/kube-prometheus-stack-grafana 3000:80 -n monitoring
# URL: http://localhost:3000
# Login: admin
# Password: (з secrets.tfvars)
```

## 📊 Як наповнити моніторинг даними?

Щоб графіки в Grafana не були пустими:

1.  Зайдіть в Grafana (http://localhost:3000).
2.  Перейдіть в **Dashboards -> New -> Import**.
3.  Завантажте ID популярних дашбордів:
    *   **315** (Kubernetes Cluster Monitoring)
    *   **6417** (Kubernetes Pods)
    *   **1860** (Node Exporter Full)
4.  Виберіть джерело даних **Prometheus**.

Тепер ви побачите реальне навантаження вашого кластера!

## 🔄 Як запустити CI/CD?

1.  В **Jenkins** створіть новий **Pipeline** job.
    *   В секції **Pipeline** виберіть "Pipeline script from SCM".
    *   SCM: **Git**.
    *   Repository URL: Ваш GitHub репозиторій з кодом Django.
    *   Script Path: `Jenkinsfile`.
2.  Натисніть **Build Now**.
3.  Після успішного білда Jenkins оновить версію в Helm Chart.
4.  **ArgoCD** побачить зміни і автоматично оновить Kubernetes.
