#!/bin/bash

#check sudo
if [ "$(id -u)" -ne 0 ]; then
    echo -e "\033[33mCorrer con SUDO\033[0m"
    exit
fi 

#Update
echo -e "${Green}Actualizando repositorio de Linux......${Color_Off}"
apt-get update


#Install Apache, Git and MariaDB
#Install required packages

echo "${Green}Verificando si apache esta instalado.....${Color_Off}"
echo
sleep 2
if dpkg --get-selections | grep apache2; then 
	echo
	echo  "Apache instalado" 
	apache2ctl -v
	echo
else
	echo
	echo "Apache no instalado, instalando....."
	echo
	apt install apache2 php libapache2-mod-php php-mysql -y
    echo
    echo "Iniciando Servicios apache....."
    systemctl start apache2 
    systemctl enable apache2 

fi
sleep 3

echo "${Green}Verificando si Git esta instalado.....${Color_Off}"
echo
sleep 2
if dpkg --get-selections | grep git; then 
        echo
        echo  "Git instalado" 
        git --version
        echo
else
        echo
        echo "Apache no instalado, instalando....."
        echo
        apt install git -y

fi 
sleep 3

echo "${Green}Verificando si MariaDB esta instalado.....${Color_Off}"
echo
sleep 2
if dpkg --get-selections | grep mariadb-server; then 
	echo
	echo  "MariaDB instalado" 
	mariadb --version
	echo
else
	echo
	echo "Apache no instalado, instalando....."
	echo
	apt install mariadb -y
    echo
    echo "Iniciando Servicios MariaDB....."
    echo
    systemctl start mariadb 
    systemctl enable mariadb 
fi

#Configure Database

$ mysql
MariaDB > CREATE DATABASE ecomdb;
MariaDB > CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
MariaDB > GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
MariaDB > FLUSH PRIVILEGES;

#Agregar datos a la database ecomdb
#Create the db-load-script.sql

cat > db-load-script.sql <<-EOF
USE ecomdb;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;

INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");

EOF
Run sql script


mysql < db-load-script.sql

#Deploy and Configure Web


#Codigo

git clone https://github.com/roxsross/The-DevOps-Journey-101.git
cp -r The-DevOps-Journey-101/CLASE-02/lamp-app-ecommerce/* /var/www/html/
mv /var/www/html/index.html /var/www/html/index.html.bkp

#Actualizar index.php
#Update index.php

sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php

              <?php
                        $link = mysqli_connect('172.20.1.101', 'ecomuser', 'ecompassword', 'ecomdb');
                        if ($link) {
                        $res = mysqli_query($link, "select * from products;");
                        while ($row = mysqli_fetch_assoc($res)) { ?>

#Test
curl http://localhost