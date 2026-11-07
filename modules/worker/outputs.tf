output "worker_id" {
  description = "ID del script Cloudflare Worker"
  value       = cloudflare_workers_script.hello.id
}

output "worker_name" {
  description = "Nombre del script Cloudflare Worker"
  value       = cloudflare_workers_script.hello.script_name
}

output "worker_url" {
  description = "URL pública predeterminada en subdominio workers.dev"
  value       = data.cloudflare_worker.hello.subdomain.url
}
