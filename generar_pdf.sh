#!/usr/bin/env bash
# ==============================================================================
# Script de regeneración de PDF para Tarea 8
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "📄 Compilando reporte_tarea_8.html a PDF..."
libreoffice --headless --convert-to pdf reporte_tarea_8.html --outdir .
cp -f "reporte_tarea_8.pdf" "Tarea 8 - Terraform Cloud.pdf"

echo "✅ PDF generado exitosamente:"
echo "   - $SCRIPT_DIR/Tarea 8 - Terraform Cloud.pdf"
