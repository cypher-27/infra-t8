variable "account_id" {
  description = "ID de la cuenta de Cloudflare"
  type        = string
}

variable "api_token" {
  description = "Token de API de Cloudflare con permisos de Workers Scripts y D1"
  type        = string
  sensitive   = true
}

variable "worker_name" {
  description = "Nombre del Cloudflare Worker"
  type        = string
  default     = "tarea8-worker"
}

variable "d1_database_name" {
  description = "Nombre de la base de datos Cloudflare D1"
  type        = string
  default     = "tarea8-db"
}

variable "azure_api_url" {
  description = "URL opcional de backend en Azure para integración híbrida"
  type        = string
  default     = ""
}
