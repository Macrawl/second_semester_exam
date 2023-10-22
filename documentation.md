
### OBJECTIVES

1. Automate the provisioning of two Ubuntu-based servers, named “Master” and “Slave”, using Vagrant.
On the Master node, create a bash script to automate the deployment of a LAMP (Linux, Apache, MySQL, PHP) stack.

This script should clone a PHP application from GitHub, install all necessary packages, and configure Apache web server and MySQL.

2. Using an Ansible playbook:
-- Execute the bash script on the Slave node and verify that the PHP application is accessible through the    VM’s IP address (take screenshot of this as evidence)

-- Create a cron job to check the server’s uptime every 12 am.

### REQUIREMENTS

Submit the bash script and Ansible playbook to (publicly accessible) GitHub repository.
Document the steps with screenshots in md files, including proof of the application’s accessibility (screenshots taken where necessary)
Use either the VM’s IP address or a domain name as the URL.


### SOLUTION

I initialised vagrant ubuntu/focal64 box for this project, and created my bash bash script file , gave it executable permission and echoed "this is a new bash script" thus setting up my environment for this exam-project. 

I automated the provisioning of two ubuntu based servers named master and slave using vagrant. 

my script for provisioning the Ubuntu Master and Slave servers is shwon below.

```
#!/bin/bash
Vagrant init ubuntu/focal64

cat << EOF > Vagrantfile
Vagrant.configure("2") do |config|

    #Master Node configuration
config.vm.define "master"  do |master|
      master.vm.hostname = "master"
      master.vm.box = "ubuntu/focal64"
      master.vm.network  "private_network", ip: "192.168.56.23"
    end
    #Slave Node Configuration
config.vm.define "slave" do |slave|
      slave.vm.hostname = "slave"
      slave.vm.box = "ubuntu/focal64"
      slave.vm.network  "private_network", ip: "192.168.56.24"
    end
    #virtualbox memory& Cpu
config.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = "2"
    end
end
EOF

vagrant up
```

#### Script to automate  LAMP stack installation 

To automate the installation of the lamp stack, 
L=> Linux
A=>Apache server
M=>MYSQL DB
P=>PHP

The script i used to automate this installation is shown below;

```
#!/bin/bash

sudo apt-get update

#indtalling Apache

sudo apt install apache2 -y


#set mysql root password 
MYSQL_ROOT_PASSWORD = "vagrant123"

sudo debconf-set-selections<<<'Mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD'

sudo debconf-set-selections<<<'Mysql-server mysql-server/root_password_again  $MYSQL_ROOT_PASSWORD'
#installing MYSQL server
sudo apt install mysql-server -y



sudo mysql_secure_installation<< EOF




#Installin PHP

sudo apt install php libapache2-mod-php php-mysql -y

#Restarting Apache server

sudo systemctl restart apache2 
```

### CONFIGURING PHP

After the installation of the lamp stack, I proceeded with configuring PHP

to get the version of php i installed, I used PHP --version command. the reason for this is so that i could know the version of php i have installed because i will be configuring the php.ini file. 


```
php --version

```

I realized that to install laravel dependencies, i needed to run ```composer install --no-dev```, I previously installed php version 7.4, which is not compatible, i ran into a series of errors due to that as shwon below. 

<img scr = "../Cloud_exam/img/composerr.png">



- My Initial installed php version

<img src = "../Cloud_exam/img/php-v.png">


- Updated PHP installation 

<img src ="../Cloud_exam/img/php8.png">



- To configure the php.ini file, I used nano text editor to do that using the code block below. 

```
sudo nano /etc/php/8.2/apache2/php.ini
```

The line we need to edit is ```cgi.fix_pathinfo=1``` so you can either search for it manually, or you can search for it using Ctrl+W. That line of code has to be edited to this ```cgi.fix_pathinfo=0``` and save. As shown below

<img src = "../Cloud_exam/img/info.png">

after configuring php.ini file, I restarted apache server

```
sudo systemctl restart apache2
```

### INSTALL COMPOSER

A PHP dependency manager, Composer keeps track of the libraries and dependencies needed by PHP programs. It is required in order to install the Laravel packages and dependencies.

to install composer, 

```
curl -sS https://getcomposer.org/installer | php 
```

After running this command, you can move the composer.phar file to a directory in your PATH environment variable to make it globally accessible.

```
sudo mv composer.phar /usr/local/bin/composer

```

To confirm that composer is installed  Run 

```
composer --version
```

<img src = "../Cloud_exam/img/comp.png">

### CONFIGURING APACHE

To begin the configuration of apache to get it ready to host my laravel application, I created an apache virtual host configuration file 

```
sudo nano /etc/apache2/sites-available/laravel.conf
```

The  virtual host configuration file below;

<img src = "../Cloud_exam/img/hostconfig.png">


### LARAVEL APP INSTALLATION

From our Apache server configuration, we established that the Laravel app will be installed on the '/var/www/html/laravel' folder. 

Apache therefore now knows that our application will be installed on that folder, we will now go ahead and create the directory and cd into it 

```
sudo mkdir /var/www/html/laravel && cd /var/www/html/laravel
```


 the application  will be by cloned from github repo  it onto the  server through Git.

 ```
 git clone https://github.com/laravel/laravel.git
 ```

