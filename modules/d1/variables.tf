variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "database_name" {
  description = "Nombre de la base de datos Cloudflare D1"
  type        = string
  default     = "tarea8-db"
}
