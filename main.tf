# ==============================================================================
# INFRAESTRUCTURA COMO CÓDIGO - TAREA 8 (REFACTORIZACIÓN MODULAR)
# Materia: Infraestructura y Desarrollo Continuo - ITESO
# Orquestación: Terraform Cloud (HCP Terraform) con VCS Trigger
# Repositorio: https://github.com/cypher-27/infra-t8
# ==============================================================================

provider "cloudflare" {
  api_token = var.api_token
}

# ------------------------------------------------------------------------------
# MÓDULO 1: Base de Datos Relacional Serverless (Cloudflare D1)
# ------------------------------------------------------------------------------
module "d1" {
  source = "./modules/d1"

  account_id    = var.account_id
  database_name = var.d1_database_name
}

# ------------------------------------------------------------------------------
# MÓDULO 2: Cómputo en el Edge y Subdominio (Cloudflare Worker)
# ------------------------------------------------------------------------------
module "worker" {
  source = "./modules/worker"

  account_id     = var.account_id
  worker_name    = var.worker_name
  d1_database_id = module.d1.database_id
  azure_api_url  = var.azure_api_url
}
