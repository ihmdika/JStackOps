#!/bin/bash

# Update OS with latest patches
sudo yum update -y

# Install EPEL Repository
sudo yum install -y epel-release

# Install wget (although it's not directly used in the script, it might be useful for other operations)
sudo yum install -y wget

# Install Erlang (RabbitMQ dependency)
sudo yum install -y https://github.com/rabbitmq/erlang-rpm/releases/download/v24.3.4/erlang-24.3.4-1.el7.x86_64.rpm

# Add RabbitMQ repo
sudo tee /etc/yum.repos.d/rabbitmq.repo <<EOF
[rabbitmq-server]
name=rabbitmq-server
baseurl=https://packagecloud.io/rabbitmq/rabbitmq-server/el/7/\$basearch
repo_gpgcheck=0
gpgcheck=1
enabled=1
gpgkey=https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey
       https://www.rabbitmq.com/rabbitmq-release-signing-key.asc
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
metadata_expire=300
EOF

# Install RabbitMQ
sudo yum install -y rabbitmq-server

# Enable and start RabbitMQ service
sudo systemctl enable --now rabbitmq-server

# Add administrative user (adjust credentials as needed)
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator

# Allow remote connections (not recommended for production without proper security measures)
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'

# Restart RabbitMQ to apply changes
sudo systemctl restart rabbitmq-server
