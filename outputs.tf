output "d1_database_id" {
  description = "ID único de la base de datos Cloudflare D1"
  value       = module.d1.database_id
}

output "d1_database_name" {
  description = "Nombre asignado a la base de datos D1"
  value       = module.d1.database_name
}

output "worker_url" {
  description = "URL pública de acceso en workers.dev gestionada por el módulo worker"
  value       = module.worker.worker_url
}
