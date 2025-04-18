#!/bin/bash
# Update packages
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Start Docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $(whoami)
# Run Docker container
sudo docker pull nginx:latest

# Create directory if it doesn't exist
sudo mkdir -p /var/www/html

# Write health check file
sudo echo "<h1>Docker container running</h1>" > /var/www/html/index.html
# Run Docker container
sudo docker run -d -p 80:80 --name my-web-app -v /var/www/html:/usr/share/nginx/html nginx:latest
