# Tarea 8: Despliegue de Infraestructura Serverless con Terraform Cloud y Módulos

[![Terraform](https://img.shields.io/badge/Terraform-1.5+-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Cloudflare](https://img.shields.io/badge/Cloudflare-Workers_%26_D1-F38020?logo=cloudflare&logoColor=white)](https://workers.cloudflare.com/)
[![Terraform Cloud](https://img.shields.io/badge/HCP_Terraform-Cloud-623CE4?logo=terraform&logoColor=white)](https://app.terraform.io/)
[![GitHub](https://img.shields.io/badge/GitHub-VCS_Driven_Workflow-181717?logo=github&logoColor=white)](https://github.com/)

Proyecto de **Infraestructura como Código (IaC)** desarrollado para la materia de **Infraestructura y Desarrollo Continuo** en el **ITESO**. Consiste en la refactorización modular de la Práctica 11 (Cloudflare Workers & Cloudflare D1) y su automatización GitOps mediante **Terraform Cloud (HCP Terraform)** vinculado a este repositorio de GitHub.

---

## 🏗️ Arquitectura de la Solución

```mermaid
flowchart LR
    subgraph VCS["Control de Versiones (GitOps)"]
        Dev["Desarrollador / git push"] -->|"Push a rama main"| GitHub["GitHub Repo (cypher-27/infra-t8)"]
    end

    subgraph TFC["Terraform Cloud (HCP Terraform)"]
        Webhook["VCS Webhook Trigger"] --> Run["Plan & Apply Remoto"]
        Vars["Variables del Workspace (account_id, api_token)"] --> Run
    end

    subgraph Edge["Cloudflare Global Network"]
        ModD1["Módulo d1: cloudflare_d1_database"]
        ModWorker["Módulo worker: cloudflare_workers_script"]
        Subdomain["Subdominio: *.workers.dev"]
    end

    GitHub -->|"Dispara ejecución automática"| Webhook
    Run -->|"Aprovisiona Base de Datos"| ModD1
    Run -->|"Aprovisiona Edge Function"| ModWorker
    ModD1 -.->|"Inyecta database_id"| ModWorker
    ModWorker --> Subdomain
```

---

## 📁 Estructura Modular del Proyecto

El código fuente fue refactorizado siguiendo los principios de modularidad, alta cohesión y bajo acoplamiento:

```text
infra-t8/
├── .gitignore                  # Exclusión de archivos de estado y credenciales
├── .terraform.lock.hcl         # Lockfile determinista de proveedores
├── versions.tf                 # Declaración de proveedores requeridos (cloudflare ~> 5.0)
├── variables.tf                # Definición de variables raíz
├── main.tf                     # Invocación y orquestación de módulos
├── outputs.tf                  # Salidas expuestas al workspace de Terraform Cloud
├── terraform.tfvars.example    # Plantilla de variables sin datos sensibles
├── README.md                   # Documentación general del repositorio
├── capturas/                   # Evidencias para el reporte
└── modules/
    ├── d1/                     # Módulo para Cloudflare D1 (Base de Datos Relacional)
    │   ├── README.md           # Documentación del módulo D1
    │   ├── versions.tf         # Proveedores requeridos
    │   ├── variables.tf        # Variables de entrada
    │   ├── main.tf             # Recurso cloudflare_d1_database
    │   └── outputs.tf          # database_id y database_name
    └── worker/                 # Módulo para Cloudflare Worker & Subdominio
        ├── README.md           # Documentación del módulo Worker
        ├── versions.tf         # Proveedores requeridos
        ├── variables.tf        # Variables de entrada (incluye d1_database_id)
        ├── main.tf             # Recursos cloudflare_workers_script y subdomain
        ├── outputs.tf          # worker_id, worker_name y worker_url
        └── worker.js           # Lógica JavaScript en Node.js/V8 para el Edge
```

---

## 🚀 Despliegue en Terraform Cloud

### 1. Variables Requeridas en el Workspace
Dentro de **Terraform Cloud -> Workspace -> Variables -> Terraform Variables**, configurar:

| Variable | Tipo | Sensible | Descripción |
| :--- | :---: | :---: | :--- |
| `account_id` | Terraform | No | Account ID de tu cuenta de Cloudflare |
| `api_token` | Terraform | **Sí (Sensitive)** | Token de API con permisos `Workers Scripts: Edit` y `D1: Edit` |
| `worker_name` | Terraform | No | Nombre del worker (e.g. `tarea8-worker`) |
| `d1_database_name` | Terraform | No | Nombre de la base de datos (e.g. `tarea8-db`) |

### 2. Flujo de Trabajo VCS (GitOps)
1. Al realizar cualquier `git push` a la rama `main`, Terraform Cloud detecta el cambio automáticamente.
2. Inicia una ejecución de tipo **Plan**.
3. Dependiendo de la configuración del workspace (automático o manual), ejecuta el **Apply**.
4. Al completarse, expone en los *Outputs* del workspace la URL pública del Worker en `*.workers.dev`.

---

## 🧪 Verificación

Una vez que el despliegue finaliza con estado **Apply Finished**, puedes verificar el servicio ejecutando:

```bash
curl -s https://<tu-worker>.<tu-subdominio>.workers.dev
```

La respuesta confirma la conexión con la base de datos SQLite serverless de Cloudflare D1 y el incremento del conteo de visitas en cada solicitud HTTP `GET`.
