#!/bin/bash
source $HOME/bin/color.dat
printf "${BLUE1}"
echo; echo "=============="
echo "SETUP NEW USER"
echo "=============="
echo; printf "${BLUE2}echo $USER"; echo 
echo; printf "${BLUE2}New username: >>> "; read myuser; echo
sudo adduser $myuser
echo; printf "${RED}Add to sudoer? (y/n) >>> "; read mysudoer; echo
if [[ $ysudoer = "y" ]]
then
  usermod -aG sudo $myuser
fi

printf "${NC}DONE"
