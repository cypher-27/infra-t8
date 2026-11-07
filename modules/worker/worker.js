export default {
  async fetch(request, env) {
    const db = env.DB;

    // 1. Asegurar tabla en D1 y registrar la visita
    try {
      await db
        .prepare(
          "CREATE TABLE IF NOT EXISTS visits (id INTEGER PRIMARY KEY AUTOINCREMENT, created_at TEXT DEFAULT CURRENT_TIMESTAMP, user_agent TEXT)"
        )
        .run();

      const userAgent = request.headers.get("user-agent") || "unknown";
      await db
        .prepare("INSERT INTO visits (user_agent) VALUES (?)")
        .bind(userAgent)
        .run();
    } catch (e) {
      console.error("Error interactuando con D1:", e);
    }

    // 2. Consultar el total de visitas acumuladas en D1
    let totalVisitas = 0;
    try {
      const count = await db
        .prepare("SELECT COUNT(*) as total FROM visits")
        .first();
      totalVisitas = count?.total ?? 0;
    } catch (e) {
      console.error("Error al contar visitas en D1:", e);
    }

    // 3. Consultar endpoint secundario en Azure si fue configurado
    let azureData = null;
    if (env.AZURE_API_URL) {
      try {
        const azureResp = await fetch(env.AZURE_API_URL, {
          headers: { "User-Agent": "Cloudflare-Worker-Terraform-Cloud" },
          signal: AbortSignal.timeout(3000)
        });
        if (azureResp.ok) {
          azureData = await azureResp.json();
        } else {
          azureData = { error: `Azure HTTP ${azureResp.status}` };
        }
      } catch (err) {
        azureData = { status: "offline_or_not_deployed", details: err.message };
      }
    }

    // 4. Retornar payload JSON unificado
    return Response.json({
      ok: true,
      mensaje: "Despliegue automatizado exitoso mediante Terraform Cloud y Módulos Reutilizables",
      materia: "Infraestructura y Desarrollo Continuo - ITESO",
      tarea: "Tarea 8 - Terraform Cloud",
      arquitectura: {
        plataforma: "Cloudflare Edge Workers + D1 Database",
        orquestador: "Terraform Cloud (HCP Terraform)",
        vcs_ci_cd: "GitHub Push Event Trigger",
        modulos: ["modules/d1", "modules/worker"]
      },
      cloudflare_d1: {
        estado: "Conectado y persistiendo en SQLite",
        visitas_totales: totalVisitas
      },
      azure_container: azureData,
      request: {
        url: request.url,
        timestamp: new Date().toISOString()
      }
    });
  },
};
