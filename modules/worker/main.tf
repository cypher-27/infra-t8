resource "cloudflare_workers_script" "hello" {
  account_id         = var.account_id
  script_name        = var.worker_name
  main_module        = "worker.js"
  content            = file("${path.module}/worker.js")
  compatibility_date = "2025-10-28"

  bindings = concat(
    [
      {
        name = "DB"
        type = "d1"
        id   = var.d1_database_id
      }
    ],
    var.azure_api_url != "" ? [
      {
        name = "AZURE_API_URL"
        type = "plain_text"
        text = var.azure_api_url
      }
    ] : []
  )
}

resource "cloudflare_workers_script_subdomain" "hello" {
  account_id  = var.account_id
  script_name = cloudflare_workers_script.hello.script_name
  enabled     = true
}

data "cloudflare_worker" "hello" {
  account_id = var.account_id
  worker_id  = cloudflare_workers_script.hello.id
}
