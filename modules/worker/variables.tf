variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "worker_name" {
  description = "Nombre del script Worker"
  type        = string
  default     = "tarea8-worker"
}

variable "d1_database_id" {
  description = "ID de la base de datos D1 para binding nativo"
  type        = string
}

variable "azure_api_url" {
  description = "URL opcional de servicio en Azure para integración multicloud"
  type        = string
  default     = ""
}
