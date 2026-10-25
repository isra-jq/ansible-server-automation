#!/usr/bin/env bash
# ==============================================================================
# Helper Script: Subir proyecto a GitHub (isra-jq/ansible-server-automation)
# ==============================================================================

set -euo pipefail

REPO_DIR="/home/isra/ansible-server-automation"
cd "$REPO_DIR"

echo "=========================================================="
echo "  Subir Proyecto a GitHub: isra-jq/ansible-server-automation"
echo "=========================================================="

# Comprobar si git está instalado en OpenSUSE
if ! command -v git &> /dev/null; then
    echo "Git nativo no está instalado en tu sistema OpenSUSE."
    echo "Instalándolo mediante zypper (requerirá tu contraseña de usuario/sudo)..."
    sudo zypper in -y git
fi

echo "1. Verificando estado del repositorio local..."
git branch -M main

echo "2. Subiendo cambios a GitHub..."
echo "(Recuerda: En 'Password' debes ingresar tu Personal Access Token de GitHub con permiso 'repo')"
git push -u origin main

echo "=========================================================="
echo "¡Proyecto subido exitosamente a:"
echo "https://github.com/isra-jq/ansible-server-automation"
echo "=========================================================="
