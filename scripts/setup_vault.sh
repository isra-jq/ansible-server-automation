#!/usr/bin/env bash
# ==============================================================================
# Helper Script: Ansible Vault Encryption & Management
# ==============================================================================

set -euo pipefail

VAULT_FILE="inventory/group_vars/all/vault.yml"
VAULT_PASS_FILE=".vault_pass"

echo "=== Ansible Vault Helper for OpenSUSE Automation ==="

if [ ! -f "$VAULT_FILE" ]; then
    echo "Error: Vault file $VAULT_FILE not found!"
    exit 1
fi

echo "1) Encrypt vault.yml (with interactive password)"
echo "2) Decrypt vault.yml (to view or edit)"
echo "3) Edit vault.yml directly (ansible-vault edit)"
echo "4) Generate random .vault_pass file and encrypt automatically"
read -rp "Select an option [1-4]: " option

case "$option" in
    1)
        ansible-vault encrypt "$VAULT_FILE"
        echo "Successfully encrypted $VAULT_FILE."
        ;;
    2)
        ansible-vault decrypt "$VAULT_FILE"
        echo "Successfully decrypted $VAULT_FILE."
        ;;
    3)
        ansible-vault edit "$VAULT_FILE"
        ;;
    4)
        openssl rand -base64 24 > "$VAULT_PASS_FILE"
        chmod 600 "$VAULT_PASS_FILE"
        ansible-vault encrypt "$VAULT_FILE" --vault-password-file "$VAULT_PASS_FILE"
        echo "Created $VAULT_PASS_FILE and encrypted $VAULT_FILE."
        echo "Remember: $VAULT_PASS_FILE is already included in .gitignore and will NOT be uploaded to Git."
        ;;
    *)
        echo "Invalid selection."
        exit 1
        ;;
esac
