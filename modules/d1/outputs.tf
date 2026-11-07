output "database_id" {
  description = "ID del recurso Cloudflare D1 Database"
  value       = cloudflare_d1_database.app.id
}

output "database_name" {
  description = "Nombre de la base de datos D1"
  value       = cloudflare_d1_database.app.name
}
