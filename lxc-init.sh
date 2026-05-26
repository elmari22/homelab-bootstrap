#!/bin/bash
set -euo pipefail
exec < /dev/tty

# Update
apt-get update && apt-get upgrade -y
apt-get install -y curl ca-certificates gnupg

# SSH key
mkdir -p /root/.ssh && chmod 700 /root/.ssh
curl -fsSL https://github.com/elmari22.keys > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo $VERSION_CODENAME) stable" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "Done."
read -p "Reboot now? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    reboot
fi
