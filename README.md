# Ansible-Projects

An Ansible-based automation tool for configuring and managing email services across your infrastructure.

## Overview

This Ansible project automates the deployment and configuration of email services, including mail servers, SMTP relay configurations, and email client setups. It provides a consistent, repeatable way to manage email infrastructure across multiple environments.

## Features

- **Automated Email Server Deployment**: Configure Postfix, Dovecot, or other mail transfer agents
- **SMTP Configuration**: Set up SMTP relay for applications
- **Email Monitoring**: Configure monitoring and alerting for mail services
- **Security Hardening**: Apply best practices for email security (SPF, DKIM, DMARC)
- **Multi-Environment Support**: Separate configurations for dev, staging, and production
- **Idempotent Operations**: Safe to run multiple times without side effects

## Prerequisites

- Ansible 2.9 or higher
- Python 3.6+
- SSH access to target hosts
- Sudo privileges on target hosts
 
## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/ansible-email-app.git
cd ansible-email-app
```

2. Install required Ansible collections:
```bash
ansible-galaxy collection install -r requirements.yml
```

3. Install Python dependencies:
```bash
pip install -r requirements.txt
```

## Project Structure

```
ansible-email-app/
├── inventories/
│   ├── production/
│   │   ├── hosts.yml
│   │   └── group_vars/
│   └── staging/
│       ├── hosts.yml
│       └── group_vars/
├── roles/
│   ├── mail_server/
│   ├── smtp_relay/
│   └── email_monitoring/
├── playbooks/
│   ├── deploy_mail_server.yml
│   ├── configure_smtp.yml
│   └── setup_monitoring.yml
├── group_vars/
│   └── all.yml
├── ansible.cfg
├── requirements.yml
└── README.md
```

## Configuration

### 1. Inventory Setup

Edit the inventory file for your environment (e.g., `inventories/production/hosts.yml`):

```yaml
all:
  children:
    mail_servers:
      hosts:
        mail01.example.com:
          ansible_host: 192.168.1.10
    smtp_relays:
      hosts:
        relay01.example.com:
          ansible_host: 192.168.1.20
```

### 2. Variables

Configure variables in `group_vars/all.yml`:

```yaml
# Email domain configuration
email_domain: example.com
smtp_host: smtp.example.com
smtp_port: 587

# SMTP authentication
smtp_username: noreply@example.com
smtp_password: "{{ vault_smtp_password }}"

# SSL/TLS settings
use_tls: true
use_ssl: false
```

### 3. Vault Secrets

Store sensitive data using Ansible Vault:

```bash
ansible-vault create group_vars/all/vault.yml
```

Add your sensitive variables:
```yaml
vault_smtp_password: your_secure_password
vault_admin_email: admin@example.com
```

## Usage

### Deploy Mail Server

```bash
ansible-playbook -i inventories/production/hosts.yml playbooks/deploy_mail_server.yml
```

### Configure SMTP Relay

```bash
ansible-playbook -i inventories/production/hosts.yml playbooks/configure_smtp.yml
```

### Setup Email Monitoring

```bash
ansible-playbook -i inventories/production/hosts.yml playbooks/setup_monitoring.yml
```

### Run with Vault Password

```bash
ansible-playbook -i inventories/production/hosts.yml playbooks/deploy_mail_server.yml --ask-vault-pass
```

### Dry Run (Check Mode)

```bash
ansible-playbook -i inventories/production/hosts.yml playbooks/deploy_mail_server.yml --check
```

## Common Tasks

### Send Test Email

```bash
ansible-playbook -i inventories/production/hosts.yml playbooks/test_email.yml \
  -e "recipient=test@example.com"
```

### Update SMTP Credentials

```bash
ansible-vault edit group_vars/all/vault.yml
ansible-playbook -i inventories/production/hosts.yml playbooks/configure_smtp.yml --ask-vault-pass
```

### Check Email Service Status

```bash
ansible mail_servers -i inventories/production/hosts.yml -m service -a "name=postfix state=started"
```

## Roles

### mail_server

Installs and configures a complete mail server stack including:
- Postfix (SMTP)
- Dovecot (IMAP/POP3)
- SpamAssassin
- Firewall rules

### smtp_relay

Configures applications to send email through SMTP relay:
- SMTP client configuration
- Authentication setup
- TLS/SSL encryption

### email_monitoring

Sets up monitoring for email services:
- Service health checks
- Queue monitoring
- Email delivery testing

## Security Considerations

- Always use Ansible Vault for sensitive data
- Enable TLS/SSL for SMTP connections
- Configure SPF, DKIM, and DMARC records
- Keep mail server software up to date
- Implement fail2ban for brute force protection
- Use strong passwords for SMTP authentication

## Troubleshooting

### Connection Issues

```bash
# Test SSH connectivity
ansible all -i inventories/production/hosts.yml -m ping

# Check Ansible configuration
ansible-config dump --only-changed
```

### Mail Delivery Problems

```bash
# Check mail queue
ansible mail_servers -i inventories/production/hosts.yml -a "mailq"

# View mail logs
ansible mail_servers -i inventories/production/hosts.yml -a "tail -n 50 /var/log/mail.log"
```

### Debugging Playbooks

Run with verbose output:
```bash
ansible-playbook -i inventories/production/hosts.yml playbooks/deploy_mail_server.yml -vvv
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Testing

Run the test suite:
```bash
# Syntax check
ansible-playbook playbooks/*.yml --syntax-check

# Linting
ansible-lint playbooks/*.yml

# Molecule tests (if configured)
molecule test
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Create an issue on GitHub
- Email: roy055659@gmail.com
- Documentation: https://github.com/abhijitray7810/Ansible-Email-App/tree/main

## Acknowledgments

- Ansible community for excellent documentation
- Contributors to the project
- Email infrastructure best practices from RFC standards

## Changelog

### Version 1.0.0 (2025-01-15)
- Initial release
- Basic mail server deployment
- SMTP relay configuration
- Email monitoring setup
