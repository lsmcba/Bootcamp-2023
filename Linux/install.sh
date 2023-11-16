#!/bin/bash

Red='\033[0;31m'    
Green='\033[0;32m'  
Yellow='\033[0;33m' 
White='\033[0;97m'

if [ "$(id -u)" -ne 0 ]; then
    echo -e "${Red}Error: Ejecutarlo con SUDO..........${Color_off}"
    exit
fi 

echo -e "${Yellow}Actualizando repositorio de Linux......${Color_Off}"
apt-get update

echo -e "${Yellow}Verificando si apache esta instalado.....${Color_Off}"
echo
sleep 2
if dpkg --get-selections | grep apache2; then 
	echo
	echo  -e "${Green}Apache instalado${Color_off}" 
	apache2ctl -v
	echo
else
	echo
	echo -e "${Red}Apache no instalado, instalando.....${Color_off}"
	echo
	apt install apache2 php libapache2-mod-php php-mysql -y
    echo
    echo -e "${Green}Apache instalado, Iniciando Servicios apache.....${Color_off}"
    systemctl start apache2 
    systemctl enable apache2 

fi
sleep 3

echo -e "${Yellow}Verificando si Git esta instalado.....${Color_Off}"
echo
sleep 2
if dpkg --get-selections | grep git; then 
        echo
        echo -e "${Green}Git instalado${Color_off}" 
        git --version
        echo
else
        echo
        echo -e "${Red}Git no instalado, instalando.....${Color_off}"
        echo
        apt install git -y
        echo
        echo  -e "${Green}Git instalado${Color_off}" 
        git --version
        echo

fi 
sleep 3

echo -e "${Yellow}Verificando si MariaDB esta instalado.....${Color_Off}"
echo
sleep 2
if dpkg --get-selections | grep mariadb-server; then 
	echo
	echo  -e "${Green}MariaDB instalado${Color_off}" 
	mariadb --version
	echo
else
	echo
	echo -e "${Red}Apache no instalado, instalando.....${Color_off}"
	echo
	apt install mariadb-server -y
    echo
    echo -e "${Green}MariaDB instalado. Iniciando Servicios MariaDB.....${Color_Off}"
    echo
    systemctl start mariadb 
    systemctl enable mariadb 
fi

echo
echo -e "${Yellow}Instalando la base de datos y usuarios, estableciendo permisos${Color_off}"
echo
sleep 2
mysql -e "CREATE DATABASE ecomdb;
	      CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
	      GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost';
	      FLUSH PRIVILEGES;"

echo
echo -e "${Yellow}Creando archivo SQL y agregarlo a la base ecommerce${Color_off}"
echo
sleep 2
cat > db-load-script.sql <<-EOF
USE ecomerce;
CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;
INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
EOF
mysql < db-load-script.sql


echo
echo -e "${Yellow}Clonando repositorio de Ecommerce${Color_off}"
echo
git clone https://github.com/roxsross/The-DevOps-Journey-101.git
cp -r The-DevOps-Journey-101/CLASE-02/lamp-app-ecommerce/* /var/www/html/
mv /var/www/html/index.html /var/www/html/index.html.bkp



echo
echo -e "${Yellow}Actualizando PHP${Color_off}"
echo
sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php
 