#!/bin/bash

# This script will automatically set up a LAMP stack on an Ubuntu instance, including MySQL setup and a PHP app.

# Update package list and upgrade packages
sudo apt update -y
sudo apt upgrade -y
# Install Apache, MySQL, and PHP
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql jq unzip
# Install AWS CLI if it's not installed
if ! command -v aws &> /dev/null; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
else
    echo "AWS CLI already installed"
fi
# Installing cloudwatch agent
# wget https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip
# unzip AmazonCloudWatchAgent.zip
# sudo ./install.sh
# sudo systemctl start amazon-cloudwatch-agent
# sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:/alarm/AWS-CWAgent -s

# Fetch the secret from Secrets Manager
SECRET_NAME=$(aws secretsmanager list-secrets --query "SecretList[?Description=='RDS instance credentials'].Name" --output text)
SECRET=$(aws secretsmanager get-secret-value --secret-id "$SECRET_NAME" --query SecretString --output text)
# Parse the secret using jq
DBUSERNAME=$(echo $SECRET | jq -r .DBUsername)
DBPASSWORD=$(echo $SECRET | jq -r .DBPassword)
DBNAME=$(echo $SECRET | jq -r .DBName)
DB_HOST=$(echo $SECRET | jq -r .RDSEndpoint)
# Create a user for running the LAMP stack (lampuser)
sudo adduser --disabled-password --gecos "" $DBUSERNAME
# Add the user to the 'www-data' group (Apache runs under www-data by default)

sudo usermod -aG www-data $DBUSERNAME
# Set correct permissions for the web directory
sudo chown -R $DBUSERNAME:www-data /var/www/html

# Configure Apache to run as lampuser
echo "export APACHE_RUN_USER=$DBUSERNAME" | sudo tee -a /etc/apache2/envvars
echo "export APACHE_RUN_GROUP=www-data" | sudo tee -a /etc/apache2/envvars
# Enable and start Apache service
sudo systemctl enable apache2
sudo systemctl start apache2
# Restart MySQL to apply changes
sudo systemctl enable mysql
sudo systemctl start mysql

# Creating database and tables in RDS
mysql -h $DB_HOST -u $DBUSERNAME -p$DBPASSWORD <<EOF
  CREATE DATABASE IF NOT EXISTS $DBNAME;
  USE $DBNAME;
  CREATE TABLE IF NOT EXISTS records (
      id INT AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      description TEXT,
      date_created DATETIME DEFAULT CURRENT_TIMESTAMP
  );
EOF
# Set the S3 bucket directory
S3_CODE_DIR="s3://lamp-code-file-1/crud_app/"
# Copy code files from S3
aws s3 cp $S3_CODE_DIR /var/www/html/crud_app --recursive
# Set correct permissions for the web directory and PHP file
sudo chown -R $DBUSERNAME:www-data /var/www/html/crud_app
sudo chmod -R 755 /var/www/html/crud_app
# Update Apache configuration
sudo tee /etc/apache2/sites-available/000-default.conf <<EOF
<VirtualHost *:80>
    # Set environment variables for database credentials
    SetEnv DB_USER "$DBUSERNAME"
    SetEnv DB_PASS "$DBPASSWORD"
    SetEnv DB_NAME "$DBNAME"
    SetEnv DB_HOST "$DB_HOST"
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    <Directory /var/www/html/crud_app>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
# Enable and restart Apache service
sudo a2enmod rewrite
sudo systemctl restart apache2
# Retrieve the public IP of the server dynamically
SERVER_IP=$(curl -s ifconfig.me)
# Print message indicating setup is complete
echo "LAMP stack setup complete. You can access the PHP app at http://$SERVER_IP/crud_app"

# Update packages
# Add Docker's official GPG key:
# sudo apt-get update
# sudo apt-get install ca-certificates curl -y
# sudo install -m 0755 -d /etc/apt/keyrings
# sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
# sudo chmod a+r /etc/apt/keyrings/docker.asc

# # Add the repository to Apt sources:
# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#   $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt-get update

# sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# # Start Docker
# sudo systemctl enable docker
# sudo systemctl start docker
# sudo usermod -aG docker $(whoami)
# # Run Docker container
# sudo docker pull nginx:latest

# # Create directory if it doesn't exist
# sudo mkdir -p /var/www/html

# # Write health check file
# sudo echo "<h1>Docker container running</h1>" > /var/www/html/index.html
# # Run Docker container
# sudo docker run -d -p 80:80 --name my-web-app -v /var/www/html:/usr/share/nginx/html nginx:latest
