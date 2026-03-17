#!/bin/bash

echo "🚀 Starting DevOps Setup..."


# Step 2: Generate Inventory
echo "🧾 Generating Ansible Inventory..."

terraform output -json | jq -r '
"[jenkins]
\(.jenkins_ip.value)

[docker]
\(.docker_ip.value)

[sonarqube]
\(.sonarqube_ip.value)

[app]
\(.app_ip.value)

[k3s]
\(.k3s_ip.value)

[monitoring]
\(.monitoring_ip.value)
"' > ansible/inventory.ini

echo "✅ Inventory created at ansible/inventory.ini"

# Step 3: Fix SSH Key Permissions
echo "🔐 Fixing SSH key permissions..."
chmod 400 server.pem

# Step 4: Test Connectivity
echo "🔍 Testing Ansible connectivity..."
ANSIBLE_HOST_KEY_CHECKING=False ansible -i ansible/inventory.ini all -m ping -u ubuntu --private-key server.pem

# Step 5: Run Base Setup
echo "⚙️ Running Base Setup..."
ansible-playbook -i ansible/inventory.ini ansible/base_setup.yml -u ubuntu --private-key server.pem

# Step 6: Install Docker
echo "🐳 Installing Docker..."
ansible-playbook -i ansible/inventory.ini ansible/docker_setup.yml -u ubuntu --private-key server.pem

# Step 7: Install Jenkins
echo "🛠️ Installing Jenkins..."
ansible-playbook -i ansible/inventory.ini ansible/jenkins_setup.yml -u ubuntu --private-key server.pem

echo "🎉 Setup Complete!"

echo "👉 Access Jenkins at: http://<JENKINS_IP>:8080"
echo "👉 Get password using:"
echo "ssh -i server.pem ubuntu@<JENKINS_IP> && sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
