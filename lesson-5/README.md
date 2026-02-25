# Урок 5: Базова інфраструктура в AWS (VPC, ECR, S3) за допомогою Terraform

Цей репозиторій містить Terraform-код для розгортання початкової AWS-інфраструктури відповідно до вимог технічного завдання 5 уроку.

## 🎯 Що реалізовано (Структура проєкту)
- **`module "s3_backend"`**: створення S3-бакета для збереження стейту (із версіонуванням) та таблиці DynamoDB для блокування одночасних запусків (state locking).
- **`module "vpc"`**: створення мережевої інфраструктури — VPC (`10.0.0.0/16`), 3 публічні та 3 приватні підмережі, Internet Gateway (для публічних підмереж), NAT Gateway та таблиці маршрутизації.
- **`module "ecr"`**: створення репозиторію Elastic Container Registry для зберігання Docker-образів (з автоматичним скануванням на вразливості `scan_on_push`).

---

## 🚀 Команди для ініціалізації та запуску

### Крок 0. Отримання ключів доступу (IAM) в AWS
Для роботи Terraform на вашому комп'ютері потрібні ключі доступу.
1. Увійдіть у веб-консоль AWS і відкрийте сервіс **IAM**.
2. Перейдіть до **Users** і натисніть **Create user**. Оберіть **"Attach policies directly"** і додайте політику **AdministratorAccess**.
3. Відкрийте створеного користувача, перейдіть на вкладку **Security credentials** -> **Create access key** (Command Line Interface).
4. Скопіюйте `Access key ID` та `Secret access key`.

Відкрийте термінал і введіть:
```powershell
aws configure
```
Вставте ключі та вкажіть ваш регіон (наприклад, `eu-central-1`). 

---

### Крок 1. Підготовка бекенду (S3 та DynamoDB)

Спершу потрібно створити S3-бакет та DynamoDB-таблицю для зберігання стейту Terraform:
```powershell
cd lesson-5

# Ініціалізуємо провайдери
terraform init

# Створюємо ЛИШЕ ресурси бекенду
terraform apply -target=module.s3_backend -auto-approve
```

### Крок 2. Міграція локального стейту в S3
Після успішного створення S3-бакета відкрийте файл `lesson-5/backend.tf` і розкоментуйте його вміст:

```hcl
terraform {
  backend "s3" {
    bucket         = "lesson-5-tf-state-eu-central-1" 
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "lesson-5-tf-locks"     
    encrypt        = true
  }
}
```

Потім перенесіть стейт-файл у хмару командою:
```powershell
terraform init -migrate-state
```
Підтвердіть дію, ввівши `yes`. Тепер стейт Terraform надійно зберігається у хмарному S3-бакеті!

---

### Крок 3. Розгортання решти інфраструктури (VPC та ECR)
Після налаштування віддаленого стейту розгортаємо мережу (VPC) та реєстр контейнерів (ECR):

```powershell
# Дивимось план змін
terraform plan

# Застосовуємо зміни
terraform apply -auto-approve
```

---

## 🧹 Очищення ресурсів (Terraform Destroy)

Щоб не сплачувати за ресурси AWS після перевірки, видаліть їх:

1. **Закоментуйте** знову блок у файлі `backend.tf`.
2. Виконайте міграцію стейту назад на локальний комп'ютер:
   ```powershell
   terraform init -migrate-state
   ```
3. Видаліть усі ресурси:
   ```powershell
   terraform destroy -auto-approve
   ```
