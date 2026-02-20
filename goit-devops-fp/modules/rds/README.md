# Universal RDS Module

Цей модуль дозволяє розгортати як звичайний RDS Instance, так і Aurora Cluster, використовуючи один і той самий код.

## 🚀 Функціонал

- **Універсальність**: Підтримка `aws_db_instance` (RDS) та `aws_rds_cluster` (Aurora).
- **Гнучкість**: Можливість вибору типу БД через змінну `use_aurora`.
- **Автоматизація**: Автоматичне створення Security Group, Subnet Group та Parameter Groups.

## 📦 Змінні (Variables)

| Назва | Тип | Опис | Дефолт |
|---|---|---|---|
| `use_aurora` | `bool` | `true` - Aurora Cluster, `false` - RDS Instance | `false` |
| `engine` | `string` | Тип двигуна БД (`postgres`, `aurora-postgresql`, `mysql`) | `postgres` |
| `engine_version` | `string` | Версія двигуна | `16.6` |
| `instance_class` | `string` | Тип інстансу (`db.t3.micro`, `db.t3.medium`) | `db.t3.micro` |
| `db_name` | `string` | Назва бази даних | `appdb` |
| `db_username` | `string` | Ім'я користувача | `dbadmin` |
| `multi_az` | `bool` | Multi-AZ deployment | `false` |

## 🛠 Приклад використання

### 1. Звичайна RDS (Free Tier)

```hcl
module "rds" {
  source = "./modules/rds"

  use_aurora     = false
  engine         = "postgres"
  engine_version = "16.6"
  instance_class = "db.t3.micro"
  
  # ... інші змінні
}
```

### 2. AWS Aurora Cluster

```hcl
module "rds" {
  source = "./modules/rds"

  use_aurora     = true
  engine         = "aurora-postgresql"
  engine_version = "16.1"
  instance_class = "db.t3.medium" # Aurora requires >= t3.medium
  
  # ... інші змінні
}
```

## ⚠️ Важливо

- **Aurora не входить у Free Tier**. Використання `use_aurora = true` призведе до витрат.
- Модуль автоматично створює відповідні Parameter Groups залежно від вибраного режиму.
