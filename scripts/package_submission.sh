#!/usr/bin/env bash
# ==============================================================================
# Helper Script: Actualizar y regenerar archivos .zip y .tar.gz tras modificaciones
# ==============================================================================

set -euo pipefail

PROJECT_DIR="/home/isra/ansible-server-automation"
DEST_HOME="/home/isra"
DEST_DESKTOP="/home/isra/Desktop"

echo "=== Empaquetando proyecto actualizado ==="

cd "$DEST_HOME"

# Crear .tar.gz actualizado
tar --exclude='.git' --exclude='*.tar.gz' --exclude='*.zip' -czf "$DEST_HOME/ansible-server-automation.tar.gz" ansible-server-automation

# Crear .zip actualizado
python3 -c "import shutil; shutil.make_archive('/home/isra/ansible-server-automation', 'zip', '$PROJECT_DIR')"

# Copiar al Escritorio
if [ -d "$DEST_DESKTOP" ]; then
    cp "$DEST_HOME/ansible-server-automation.tar.gz" "$DEST_DESKTOP/"
    cp "$DEST_HOME/ansible-server-automation.zip" "$DEST_DESKTOP/"
fi

echo "¡Listo! Paquetes actualizados exitosamente en:"
echo " - $DEST_HOME/ansible-server-automation.zip"
echo " - $DEST_HOME/ansible-server-automation.tar.gz"
echo " - $DEST_DESKTOP/ansible-server-automation.zip"
echo " - $DEST_DESKTOP/ansible-server-automation.tar.gz"
