#!/usr/bin/env bash
# ==============================================================================
# Execution Helper: Run Ansible Automation
# ==============================================================================

set -euo pipefail

INVENTORY="inventory/hosts.ini"
VAULT_PASS_FILE=".vault_pass"

EXTRA_ARGS=()
if [ -f "$VAULT_PASS_FILE" ]; then
    EXTRA_ARGS+=("--vault-password-file" "$VAULT_PASS_FILE")
fi

echo "=========================================================="
echo "  OpenSUSE 16.0 Ansible Server Automation Launcher"
echo "=========================================================="
echo "1) Run FULL Infrastructure Deployment (site.yml)"
echo "2) Run LAMP Stack Only (Apache, PHP, MariaDB, PhpMyAdmin)"
echo "3) Run Samba Sharing Only"
echo "4) Run vsftpd Secure FTP Only"
echo "5) Run PostgreSQL Role Only (Task 5)"
echo "6) Test Ping Connectivity"
echo "=========================================================="
read -rp "Enter choice [1-6]: " choice

case "$choice" in
    1)
        ansible-playbook -i "$INVENTORY" site.yml "${EXTRA_ARGS[@]}"
        ;;
    2)
        ansible-playbook -i "$INVENTORY" playbooks/lamp.yml "${EXTRA_ARGS[@]}"
        ;;
    3)
        ansible-playbook -i "$INVENTORY" playbooks/samba.yml "${EXTRA_ARGS[@]}"
        ;;
    4)
        ansible-playbook -i "$INVENTORY" playbooks/ftp.yml "${EXTRA_ARGS[@]}"
        ;;
    5)
        ansible-playbook -i "$INVENTORY" playbooks/postgresql.yml "${EXTRA_ARGS[@]}"
        ;;
    6)
        ansible -i "$INVENTORY" opensuse_servers -m ping
        ;;
    *)
        echo "Invalid option."
        exit 1
        ;;
esac
