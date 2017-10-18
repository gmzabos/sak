#!/bin/bash
#
# gmzgames.de@googlemail.com    18.10.2017
#
# Install Docker on RHEL7 (https://docs.docker.com/engine/installation/linux/rhel/)
#
# Prerequisites:
#

#########################################
# Set Variables
#########################################

#########################################
# Get Docker engine
#########################################
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

sudo yum install docker-engine-1.11.2
sudo systemctl enable docker.service
sudo systemctl start docker

#########################################
# Create a Docker group
#########################################
sudo groupadd docker
sudo usermod -aG docker ec2-user

#########################################
# Start docker at startup as daemon
#########################################
sudo systemctl enable docker
