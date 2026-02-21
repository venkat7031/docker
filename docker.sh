#!/bin/bash

# Install Docker
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start & Enable Docker
systemctl daemon-reload
systemctl enable --now docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Expand Disk (verify partition before using 4)
growpart /dev/nvme0n1 4 || true

# Extend LVM (make sure names are correct for your AMI)
lvextend -L +20G /dev/RootVG/rootVol || true
lvextend -L +10G /dev/RootVG/varVol || true

# Grow filesystem
xfs_growfs /
xfs_growfs /var