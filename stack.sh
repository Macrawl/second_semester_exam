
#!/bin/bash

#Variables

Mysql_root_passwd ="V@grant123"

#Update package repository
sudo apt-get update

#installing Apache

sudo apt-get install apache2 -y


sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $Mysql_root_passwd"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $Mysql_root_passwd"


#installing MYSQL server
sudo apt-get install mysql-server

#Installing PHP

sudo add-apt-repository -y ppa:ondrej/php

sudo apt-get update
sudo apt-get install libapache2-mod-php php php-common php-xml php-mysql php-gd php-mbstring php-tokenizer php-json php-bcmath php-curl php-zip unzip -y

#Restarting Apache server

sudo systemctl restart apache2 

#Configuring Apache for laravel app 

cat << EOF > /etc/apache2/sites-available/laravel.conf
<VirtualHost *:80>
    ServerAdmin rawlingsfdf@gmail.com
    ServerName 192.168.56.23
    DocumentRoot /var/www/html/laravel/public

    <Directory /var/www/html/laravel>
    Options Indexes MultiViews FollowSymLinks
    AllowOverride All
    Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF
# enable the Apache rewrite module, and activate the Laravel virtual host
sudo a2enmod rewrite

sudo a2ensite laravel.conf

#Restart Apache server
sudo systemctl restart apache2

sudo mkdir /var/www/html/laravel && cd /var/www/html/laravel/laravel

#Cloning the laravel repo from Github

git clone https://github.com/laravel/laravel.git

#Run composer to install laravel dependencies.

composer install --no-dev

#laravel permissions 
sudo chown -R www-data:www-data /var/www/html/laravel

sudo chmod -R 775 /var/www/html/laravel

sudo chmod -R 775 /var/www/html/laravel/storage

sudo chmod -R 775 /var/www/html/laravel/bootstrap/cache

#Apache configuration to serve the app by copying .env.example  to .env 

sudo cp .env.example .env


