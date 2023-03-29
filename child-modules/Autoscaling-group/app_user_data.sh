#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras install php8.0 mariadb10.5
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

sudo cd /var/www/html
sudo touch index.html
sudo echo "Hello World" >> index.html

sudo usermod -a -G apache ssm-user
sudo chown -R ssm-user:apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;