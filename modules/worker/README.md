# Cloudflare Worker Terraform Module

Este módulo aprovisiona una función serverless en el Edge (**Cloudflare Worker**), la vincula (*binding*) nativamente a una base de datos relacional **Cloudflare D1** y activa su subdominio público en `*.workers.dev`.

## Uso

```hcl
module "worker" {
  source         = "./modules/worker"
  account_id     = var.account_id
  worker_name    = "tarea8-worker"
  d1_database_id = module.d1.database_id
  azure_api_url  = var.azure_api_url # Opcional
}
```

## Inputs

| Nombre | Descripción | Tipo | Default | Requerido |
| :--- | :--- | :--- | :--- | :---: |
| `account_id` | Cloudflare Account ID | `string` | n/a | sí |
| `worker_name` | Nombre del script Worker | `string` | `"tarea8-worker"` | no |
| `d1_database_id` | Identificador de la base de datos D1 para binding | `string` | n/a | sí |
| `azure_api_url` | URL opcional de backend en Azure para integración multicloud | `string` | `""` | no |

## Outputs

| Nombre | Descripción |
| :--- | :--- |
| `worker_id` | ID asignado al Worker en Cloudflare |
| `worker_name` | Nombre del script Worker |
| `worker_url` | URL pública de acceso global en `*.workers.dev` |

## Recursos Creados

* `cloudflare_workers_script.hello`
* `cloudflare_workers_script_subdomain.hello`
* `data.cloudflare_worker.hello`
