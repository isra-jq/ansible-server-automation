================================================================================
ANSIBLE SERVER AUTOMATION - OPENSUSE 16.0
================================================================================

a) Link to GitHub Repository:
--------------------------------------------------------------------------------
GitHub URL: https://github.com/isra-jq/ansible-server-automation

NOTE: Access and collaboration invitation sent to: gcussi@yahoo.com


b) Steps to Run the Ansible Project:
--------------------------------------------------------------------------------

1. PREREQUISITES ON CONTROL NODE (Machine running Ansible):
   - Python 3.8+ and Ansible Core 2.15+ installed.
   - Install required Ansible collections:
     $ ansible-galaxy collection install community.general community.mysql community.postgresql ansible.posix

2. TARGET SYSTEM (OpenSUSE 16.0):
   - Ensure the OpenSUSE host is accessible via SSH with root or sudo user.
   - Copy your SSH public key to the target OpenSUSE server:
     $ ssh-copy-id root@<OPENSUSE_IP>

3. CONFIGURE INVENTORY (No plaintext passwords):
   - Edit "inventory/hosts.ini" and set the target IP or hostname:
     [opensuse_servers]
     opensuse-node01 ansible_host=192.168.1.100 ansible_user=root ansible_ssh_private_key_file=~/.ssh/id_rsa

4. CREDENTIALS & ANSIBLE VAULT SETUP (Best Practice):
   - Review or customize variables in:
     "inventory/group_vars/all/vars.yml"
     "inventory/group_vars/all/vault.yml"
   - Encrypt the vault file with a secure master password:
     $ ansible-vault encrypt inventory/group_vars/all/vault.yml
     (You will be prompted to set a vault password).

5. TEST CONNECTIVITY AND OS RECOGNITION:
   - Ping the managed OpenSUSE node:
     $ ansible -i inventory/hosts.ini opensuse_servers -m ping

6. EXECUTE THE MASTER PLAYBOOK (All Tasks: Task 3 & Task 5):
   - If using Ansible Vault:
     $ ansible-playbook -i inventory/hosts.ini site.yml --ask-vault-pass
   - Or if using a vault password file (.vault_pass):
     $ ansible-playbook -i inventory/hosts.ini site.yml --vault-password-file .vault_pass
   - If running with default unencrypted lab vault:
     $ ansible-playbook -i inventory/hosts.ini site.yml

7. EXECUTE INDIVIDUAL PLAYBOOKS (Optional):
   - Deploy only LAMP & PhpMyAdmin:
     $ ansible-playbook -i inventory/hosts.ini playbooks/lamp.yml
   - Deploy only Samba file sharing:
     $ ansible-playbook -i inventory/hosts.ini playbooks/samba.yml
   - Deploy only Secure FTP (vsftpd):
     $ ansible-playbook -i inventory/hosts.ini playbooks/ftp.yml
   - Deploy only PostgreSQL (Task 5):
     $ ansible-playbook -i inventory/hosts.ini playbooks/postgresql.yml

8. PERFORMANCE OPTIMIZATION NOTES:
   - Execution speed is optimized in "ansible.cfg" using:
     * SSH Pipelining enabled (pipelining = True)
     * Connection Multiplexing (ControlMaster=auto, ControlPersist=600s)
     * Parallel execution (forks = 10)
     * Smart fact caching with jsonfile storage.

================================================================================
Generated for: Grover Humberto Cussi Nicolas
================================================================================
