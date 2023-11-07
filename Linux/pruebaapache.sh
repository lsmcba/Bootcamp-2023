#!/bin/bash

echo "${Green}Verificando si Apache esta instalado.....${Color_Off}"
echo
sleep 2
if dpkg grep apache2 >/dev/null 2>&1; then 
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
    echo
    systemctl start apache2 
    systemctl enable apache2 
    systemctl status apache2 

fi
sleep 3

echo "${Green}Verificando si Git esta instalado.....${Color_Off}"
echo
sleep 2
if dpkg grep git >/dev/null 2>&1; then 
        echo
        echo  "Git instalado" 
        git -v
        echo
else
        echo
        echo "Git no instalado, instalando....."
        echo
        apt install git -y

fi 
sleep 3

echo "${Green}Verificando si MariaDB esta instalado.....${Color_Off}"
echo
sleep 2
if dpkg grep mariadb-server >/dev/null 2>&1; then 
	echo
	echo  "MariaDB instalado" 
	mariadb -v
	echo
else
	echo
	echo "MariaDB no instalado, instalando....."
	echo
	apt install mariadb-server -y
        echo
    echo
    echo "Iniciando Servicios MariaDB....."
    echo
    systemctl start mariadb 
    systemctl enable mariadb 
    systemctl status mariadb 
fi
