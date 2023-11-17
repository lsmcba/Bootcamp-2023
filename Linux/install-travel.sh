#!/bin/bash

Red='\033[0;31m'
Green='\033[0;32m'
Yellow='\033[0;33m'
repo="bootcamp-devops-2023"

if [ "$(id -u)" -ne 0 ]; then
    echo -e "${Red}Error: Ejecutarlo con SUDO..........${Color_off}"
    exit
fi

echo
echo -e "${Green}Actualizando repositorio de Linux......${Color_Off}"
echo
apt-get update
sleep 2

echo
echo -e "${Yellow}Verificando si apache esta instalado.....${Color_Off}"
echo
if dpkg --get-selections | grep apache2; then
	echo
	echo  -e "${Green}Apache instalado${Color_off}"
	apache2ctl -v
        php -v
	echo
else
	echo
	echo -e "${Red}Apache no instalado, instalando.....${Color_off}"
	echo
	apt install apache2 php libapache2-mod-php php-mysql -y
    echo
    echo -e "${Green}Apache instalado, Iniciando Servicios apache.....${Color_off}"
    echo
    apache2ctl -v
    php -v
    systemctl start apache2
    systemctl enable apache2

fi
sleep 2

echo
echo -e "${Yellow}Verificando si Git esta instalado.....${Color_Off}"
echo
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
sleep 2

echo
echo -e "${Yellow}Verificando si MariaDB esta instalado.....${Color_Off}"
echo
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
	mariadb --version
    echo
    echo -e "${Green}MariaDB instalado. Iniciando Servicios MariaDB.....${Color_Off}"
    echo
    systemctl start mariadb
    systemctl enable mariadb
fi
sleep 2

echo
echo -e "${Yellow}Creacion de base de datos....${Color_off}"
echo
existedb=$(mysql --batch --skip-column-names -e "SHOW DATABASES LIKE 'devopstravel';" | grep "devopstravel" > /dev/null; echo "$?")
if [ $existedb -eq 0 ];then
	echo
	echo -e "${Green}La base de datos devopstravel ya existe, se salteara la instalacion de datos en la base....${Color_off}"
	echo
else
	echo
	echo -e "${Green}Instalando la base de datos y usuarios, estableciendo permisos....${Color_off}"
	echo
	sleep 2
	mysql -e "CREATE DATABASE devopstravel;
        	  CREATE USER 'codeuser'@'localhost' IDENTIFIED BY 'codepass';
          	  GRANT ALL PRIVILEGES ON *.* TO 'codeuser'@'localhost';
          	  FLUSH PRIVILEGES;"
fi

echo
echo -e "${Yellow}Clonando repositorio de Travel....${Color_off}"
echo
if [ -d "$repo" ]; then
   	 echo
	 echo -e "${Green}La carpeta $repo ya existe, actualizando...${Color_off}"
    	 echo
	 cd $repo
	 git pull
	 cd ..
else
	 echo
	 echo -e "${Green}No existe el repositorio local, clonando....${Color_off}"
	 echo
	 git clone -b clase2-linux-bash https://github.com/roxsross/$repo.git
	 cp -r $repo/app-295devops-travel/* /var/www/html
	 mv /var/www/html/index.html /var/www/html/index.html.bkp
fi
sleep 2

echo
echo -e "${Yellow}Agregando datos a la base....${Color_off}"
echo
existetb=$(mysql -e "USE devopstravel; SHOW TABLES LIKE 'booking';" | grep "booking" > /dev/null; echo "$?")
if [ $existetb -eq 0 ];then
        echo
        echo -e "${Green}La tabla Booking ya existe, se salteara la instalacion de datos en la base....${Color_off}"
        echo
else
        echo
        echo -e "${Green}Agregando la tabla Booking a la base de datos....${Color_off}"
        echo
 	mysql < $repo/app-295devops-travel/database/devopstravel.sql
	sleep 2
fi


echo
echo -e "${Yellow}Actualizando PHP....${Color_off}"
echo
sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /etc/apache2/mods-enabled/dir.conf
sed -i 's/""/"codepass"/g' /var/www/html/config.php
sleep 2

echo
echo -e "${Yellow}Reiniciando servidor apache...${Color_off}"
echo
systemctl reload apache2
sleep 2
