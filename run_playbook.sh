# Staging
ansible-playbook playbooks/deploy_mail_server.yml

# Production with vault
ansible-playbook -i inventories/production/hosts.yml playbooks/deploy_mail_server.yml --ask-vault-pass
