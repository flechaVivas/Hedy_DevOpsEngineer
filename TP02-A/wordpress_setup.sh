#!/bin/bash

# Install Nginx
sudo apt-get install -y nginx

# Install PHP
sudo apt install apt-transport-https
sudo curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
sudo apt update
sudo apt install -y php8.3 php8.3-fpm php8.3-mysql

# Install MariaDB
sudo apt install -y mariadb-server

# Create MySQL Database and a user for WordPress
sudo mariadb -e "
CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'wgtXDS156V%]';
GRANT ALL ON wordpress.* TO 'wordpress'@'localhost';
FLUSH PRIVILEGES;"

# Configure Nginx for WordPress site
sudo bash -c 'echo "
server {
    listen 80;
    server_name wordpress.facundovivas.cloud;
    root /var/www/wordpress;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \\.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
    }

    location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt { log_not_found off; access_log off; allow all; }
    location ~* \\.(css|gif|ico|jpeg|jpg|js|png)$ {
        expires max;
        log_not_found off;
    }
}" > /etc/nginx/sites-available/wordpress'

sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx

# Install WordPress
sudo mkdir -p /var/www/wordpress
sudo curl -LO https://wordpress.org/latest.tar.gz
sudo tar xzvf latest.tar.gz -C /var/www/wordpress --strip-components=1
sudo chown -R www-data:www-data /var/www/wordpress

# Set up WordPress configuration
sudo cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
sudo sed -i "s/database_name_here/wordpress/" /var/www/wordpress/wp-config.php
sudo sed -i "s/username_here/wordpress/" /var/www/wordpress/wp-config.php
sudo sed -i "s/password_here/wgtXDS156V%]/" /var/www/wordpress/wp-config.php

# Start services
sudo systemctl start nginx
sudo systemctl start php8.3-fpm