#!/usr/bin/env python3
"""
==============================================================================
OpenSUSE 16.0 Server Automation - Python Deployment & Management Console
==============================================================================
Este script permite gestionar y desplegar la infraestructura utilizando Python,
manteniendo la compatibilidad total con los Roles de Ansible exigidos en la tarea.
"""

import os
import sys
import subprocess
import shutil

PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))
INVENTORY = os.path.join(PROJECT_DIR, "inventory", "hosts.ini")
SITE_PLAYBOOK = os.path.join(PROJECT_DIR, "site.yml")


def print_banner():
    print("""
==============================================================================
   🚀 OPENSUSE 16.0 - AUTOMATIZACIÓN DE SERVIDORES (PYTHON LAUNCHER)
==============================================================================
    """)


def check_ansible_installed():
    """Verifica si ansible-playbook está instalado en el sistema."""
    if not shutil.which("ansible-playbook"):
        print("[!] Ansible no está instalado en el sistema.")
        print("[*] En OpenSUSE puedes instalarlo con: sudo zypper in -y ansible")
        return False
    return True


def run_command(cmd, description):
    """Ejecuta un comando del sistema y muestra su salida en tiempo real."""
    print(f"\n[*] Iniciando: {description}...")
    print(f"[*] Comando: {' '.join(cmd)}\n" + "-" * 60)
    try:
        process = subprocess.Popen(
            cmd,
            cwd=PROJECT_DIR,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            bufsize=1
        )
        for line in process.stdout:
            print(line, end="")
        process.wait()
        if process.returncode == 0:
            print("-" * 60 + f"\n[✔] {description} completado con ÉXITO.\n")
            return True
        else:
            print("-" * 60 + f"\n[✘] Error durante: {description} (Código de salida: {process.returncode})\n")
            return False
    except Exception as e:
        print(f"\n[✘] Excepción al ejecutar comando: {e}\n")
        return False


def deploy_full():
    """Lanza el despliegue completo de la infraestructura."""
    cmd = ["ansible-playbook", "-i", INVENTORY, SITE_PLAYBOOK]
    return run_command(cmd, "Despliegue Completo de Infraestructura (LAMP, Samba, FTP, PostgreSQL)")


def deploy_lamp():
    """Lanza solo la pila LAMP (Apache, PHP, MariaDB, PhpMyAdmin)."""
    playbook = os.path.join(PROJECT_DIR, "playbooks", "lamp.yml")
    cmd = ["ansible-playbook", "-i", INVENTORY, playbook]
    return run_command(cmd, "Despliegue de LAMP Stack (Apache, PHP, MariaDB, PhpMyAdmin)")


def deploy_samba():
    """Lanza solo el servicio Samba."""
    playbook = os.path.join(PROJECT_DIR, "playbooks", "samba.yml")
    cmd = ["ansible-playbook", "-i", INVENTORY, playbook]
    return run_command(cmd, "Despliegue de Compartición de Recursos Samba")


def deploy_ftp():
    """Lanza solo el servicio FTP."""
    playbook = os.path.join(PROJECT_DIR, "playbooks", "ftp.yml")
    cmd = ["ansible-playbook", "-i", INVENTORY, playbook]
    return run_command(cmd, "Despliegue de Servidor FTP (vsftpd Seguro)")


def deploy_postgresql():
    """Lanza solo el servicio PostgreSQL (Task 5)."""
    playbook = os.path.join(PROJECT_DIR, "playbooks", "postgresql.yml")
    cmd = ["ansible-playbook", "-i", INVENTORY, playbook]
    return run_command(cmd, "Despliegue de PostgreSQL con SSL (Task 5)")


def ping_hosts():
    """Prueba la conectividad con el servidor OpenSUSE."""
    cmd = ["ansible", "-i", INVENTORY, "opensuse_servers", "-m", "ping"]
    return run_command(cmd, "Prueba de Conectividad (Ping SSH)")


def main():
    print_banner()
    
    print("Selecciona qué deseas ejecutar:")
    print("  1) Despliegue COMPLETO (Task 3 y Task 5)")
    print("  2) Desplegar solo LAMP y PhpMyAdmin")
    print("  3) Desplegar solo Samba (con create mask)")
    print("  4) Desplegar solo FTP (vsftpd enjaulado)")
    print("  5) Desplegar solo PostgreSQL con SSL (Task 5)")
    print("  6) Probar conectividad con OpenSUSE (Ping)")
    print("  0) Salir")
    print("=" * 60)
    
    choice = input("\nIngresa tu opción [0-6]: ").strip()
    
    actions = {
        "1": deploy_full,
        "2": deploy_lamp,
        "3": deploy_samba,
        "4": deploy_ftp,
        "5": deploy_postgresql,
        "6": ping_hosts
    }
    
    if choice == "0":
        print("Saliendo...")
        sys.exit(0)
    elif choice in actions:
        actions[choice]()
    else:
        print("[!] Opción no válida.")


if __name__ == "__main__":
    main()
