# Cloudflare D1 Database Terraform Module

Este módulo aprovisiona una base de datos relacional serverless basada en SQLite en **Cloudflare D1**.

## Uso

```hcl
module "d1" {
  source        = "./modules/d1"
  account_id    = var.account_id
  database_name = "mi-base-de-datos"
}
```

## Inputs

| Nombre | Descripción | Tipo | Default | Requerido |
| :--- | :--- | :--- | :--- | :---: |
| `account_id` | Cloudflare Account ID | `string` | n/a | sí |
| `database_name` | Nombre para la base de datos D1 | `string` | `"tarea8-db"` | no |

## Outputs

| Nombre | Descripción |
| :--- | :--- |
| `database_id` | Identificador único (UUID) de la base de datos D1 en Cloudflare |
| `database_name` | Nombre de la base de datos creada |

## Recursos Creados

* `cloudflare_d1_database.app`
