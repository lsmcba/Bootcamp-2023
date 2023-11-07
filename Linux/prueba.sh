#!/bin/bash


echo -e "${Green}This is GREEN text${Color_Off} and normal text"
echo -e "${Red}${On_White}This is Red test on White background${Color_Off}" 
# option -e is mandatory, it enable interpretation of backslash escapes
printf "${Red} This is red \n"
