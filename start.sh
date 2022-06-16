#!/bin/bash
clear
cd $HOME
ts=$(date +"%s")
sudo rm -rf /tmp-restic-restore
myspeed="2"
#######################################################
echo "version 107"; sleep $myspeed
#######################################################
cd $HOME
ts=$(date +"%s")
if [[ -d start2 ]]
then
  mv start2 start2-backup-$ts
fi
if [[ ! -f color.dat ]]
then
  wget https://raw.githubusercontent.com/abraxas678/start2/main/color.dat
fi
source $HOME/color.dat
#tput cup 1 0 && tput ed; 
echo "[1] DEFINE USERNAME"
echo "[2] INSTALL ZSH -- Oh-my-Zsh -- Antigen FRAMEWORK"
echo "[3] CLONE REPOSITORY"
echo "[4] SETUP RCLONE"
echo "[5] SETUP GPG"
echo ""
#tput cup 7 0 && tput ed
 #  [1] DEFINE USERNAME
 #################################################### [1] DEFINE USERNAME
  printf "${NC}"; printf "${BLUE2}"
  echo; echo; echo "CURRENT USER DETAILS:"; echo; sleep 1
  printf "${NC}"; printf "${BLUE3}"
  echo $USER; echo; sleep 1; id
  printf "${NC}"; printf "${BLUE2}"; 
  echo
  printf "${NC}"; printf "${BLUE2}USE "; printf "${RED}$USER"; printf "${BLUE2} AS USERNAME? (y/n)"
  read -n 1 myanswer
  if [[ $myanswer -ne "y" ]]
  then
    echo; echo; printf "USERNAME TO USE: >>> "; read myuser
    printf "${NC}"; printf "${BLUE3}"
    echo; echo "USING $myuser"; echo; printf "${YELLOW}"; echo BUTTON; printf "${BLUE3}"; read me
    echo; echo "sudo chown $myuser:1000 $HOME -R"
     echo "sudo chmod 700 -R $HOME"
    sudo chown $myuser:100 $HOME -R
    sudo chmod 700 -R $HOME
  fi 
echo
printf "${NC}"; printf "${BLUE2}"; 
echo; printf "DEFINE SPEED (default=2): "; read -n 1 myspeed; echo
printf "${NC}"; printf "${BLUE3}"
echo "speed [$myspeed]"
myspeed1=$(($myspeed-1))
if [[ $myspeed1 -lt "0" ]]
then
  myspeed1=0
fi
myspeed2=$(($myspeed+5))
echo "lower speed [$myspeed1]"
printf "${NC}"; printf "${BLUE2}"; 
echo; printf "restic password: >>> "
printf "${NC}"; printf "${BLUE3}"
read -n 4 mresticpw
echo
export RESTIC_REPOSITORY=rclone:gd:restic
export RESTIC_PASSWORD=$myresticpw
echo
printf "rclone password: >>> " 
read RCLONE_CONFIG_PASS
export RCLONE_CONFIG_PASS=$RCLONE_CONFIG_PASS
tput cup 15 0 && tput ed
#tput cup 10 10
#delstart="n"
#echo; echo "DELETE FOLDER START? (y/n)"; echo
#read -n 1 -t 5 delstart
#if [[ $delstart = "y" ]]
#then
#  cd $HOME
#  rm -rf 
#fi

# if [[ -f mylastupdate.log &&  "$(($ts-$(cat mylastupdate.log)))" > "86400" ]]
#  then
  echo
  printf "${LILA}"; printf "${UL1}"
  echo; echo "[1] SYSTEM UPATE AND UPGRADE"; sleep $myspeed
  ##########################################  [1] SYSTEM UPATE AND UPGRADE
  printf "${NC}"; printf "${BLUE3}"
  printf "${NC}"; printf "${BLUE2}PERFORM "; printf "${RED}sudo apt-get update && sudo apt-get upgrade -y"; printf "${BLUE2}? (y/n)"
  read -n 1 myanswer
  if [[ $myanswer -ne "y" ]]
  then
    echo "sudo apt-get update && sudo apt-get upgrade -y"
    echo; sleep 1
    sudo apt-get update && sudo apt-get upgrade -y
  fi
  echo "$EDITOR=/usr/bin/nano" >> $HOME/.bashrc
  source $HOME/.bashrc
  sudo apt-get install tmux tmuxinator
  ############  >>>>>>>>>>>>>>>>>>>>>>>   tmux new-session -d -s "Start2" $HOME/main_script.sh
  echo
  printf "${LILA}"; printf "${UL1}"
  echo "[2] INSTALL ZSH -- Oh-my-Zsh -- Antigen FRAMEWORK"; sleep $myspeed
  #############################################  [2] INSTALL ZSH -- Oh-my-Zsh -- Antigen FRAMEWORK
  printf "${NC}"; printf "${BLUE3}"
  printf "${NC}"; printf "${BLUE2}"
  echo; echo INSTALL ZSH
  printf "${NC}"; printf "${BLUE3}"echo; cd $HOME
  sudo apt install -y zsh php
  printf "${NC}"; printf "${BLUE2}"
  echo; echo INSTALL OH MY ZSH
  printf "${NC}"; printf "${BLUE3}"
  sleep $myspeed; echo
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  curl -L git.io/antigen > antigen.zsh
  echo
  printf "${LILA}"; printf "${UL1}"

echo $ts > mylastupdate.log
#else
#printf "${NC}"; printf "${RED}"
#echo "last update was $(($($ts-cat mylastupdate.log))) seconds ago. skipping two steps."; sleep $myspeed
#echo
#printf "${NC}"; printf "${BLUE3}"
#fi

echo "[3] CLONE REPOSITORY"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
######################################################################## [3] CLONE REPOSITORY
cd $HOME
sleep $myspeed
git clone https://github.com/abraxas678/start2.git; echo

############################################################# weg
#if [[ $(which gpg) = *"/usr/bin/gpg"* ]]
#then
#  echo; echo gpg INSTALLED
#  sleep $myspeed
#else
#  echo; echo INSTALL gpg
#  sleep $myspeed
#  apt install gpg -y
#  echo
  #echo SETUP GPG MANUALLY VIA OD VAULT
  #echo gpg --import
#  echo
#  echo "gpg -a --export-secret-keys [key-id] >key.asc"
#  echo "gpg --import"
#  echo
#  echo rko files to gd:sec please
#  echo
#  echo START IMPORT
#  read me
#  rclone copy gd:sec ./tempinstall --include="rko-p*" -Pc --max-depth 1
#  gpg --import ./tempinstall/rko-p*
#  rm -f ./tempinstall/rko-p*
#  echo; echo REMOVE rko files from gd:sec now; echo
#  echo; echo 
#  read me
#fi
############################################################################ weg nach oben

echo
printf "${LILA}"; printf "${UL1}"
echo "CHECKING ENVIRONMENT CONDITION:"; echo; sleep $myspeed
printf "${NC}"; printf "${LILA}"; 
echo "GPG"; echo; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"

### >>> IF 1 O
if [[ $(which gpg) = *"/usr/bin/gpg"* ]]
then
  echo GPG_INSTALLED=1; sleep $myspeed1
  GPG_INSTALLED=1
### >>> IF 2 O
   if [[ $(sudo gpg --list-secret-keys) -gt "0" ]]
   then
     echo "GPG_KEYS=1"; sleep $myspeed1
     GPG_KEYS=1
   else
     echo "GPG_KEYS=0"; sleep $myspeed1
     GPG_KEYS=0
### >>> IF 2 C
   fi
### >>> IF 1 E
else
  echo "GPG_INSTALLED=0"; sleep $myspeed1
  echo "GPG_KEYS=0"; sleep $myspeed1
  GPG_INSTALLED=0
  GPG_KEYS=0
### >>> IF 1 C
fi

printf "${LILA}"; 
echo; echo "RCLONE"; echo; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"

### >>> IF 1 O
if [[ $(which rclone) = *"/usr/bin/rclone"* ]]
then
  echo "RCLONE_INSTALL=1"; sleep $myspeed1
  RCLONE_INSTALL=1
### >>> IF 2 O
if [[ ! -f ~/.config/rclone/rclone.conf ]]; then
    echo "RCLONE_CONFIG=0"; sleep $myspeed1
    RCLONE_CONFIG=0
 ### >>> IF 2 E
  else
    echo "RCLONE_CONFIG=1"; sleep $myspeed1
    RCLONE_CONFIG=1
    rclonesize=$(rclone size ~/.config/rclone/rclone.conf --json | jq .bytes)
    #echo "rlone.conf SIZE: $rclonesize"
    #echo
### >>> IF 3 O
    if [[ $rclonesize -lt 3000 ]]
    then
### >>> IF 4 O
        if [[ $(rclone listremotes | grep gd:) = "gd:" ]]
        then
          echo "RCLONE_GD=1"; sleep $myspeed1
          RCLONE_GD=1
        else
          echo "RCLONE_GD=0"; sleep $myspeed1
          RCLONE_GD=0
          echo "RCLONE_COMPLETE=0"; sleep $myspeed1
          echo; echo "SETUP GOOGLE DRIVE NOW"; echo; sleep $myspeed
          RCLONE_COMPLETE=0
          rclone config
        fi 
 ### >>> IF 4 C
    elif [[ $rclonesize -gt 6000 ]]
    then
      RCLONE_GD=1
      RCLONE_COMPLETE=1
      echo "RCLONE_GD=1"; sleep $myspeed1
      echo "RCLONE_COMPLETE=1"; sleep $myspeed1
    fi
 ### >>> IF 3 C
### >>> IF 2 C
  fi
### >>> IF 1 E
else
  echo "RCLONE_INSTALL=0"; sleep $myspeed1
  echo "RCLONE_CONFIG=0"; sleep $myspeed1
  echo "RCLONE_GD=0"; sleep $myspeed1
  eccho "RCLONE_COMPLETE=0"; sleep $myspeed1
  RCLONE_INSTALL=0
  RCLONE_CONFIG=0
  RCLONE_GD=0
  RCLONE_COMPLETE=0
### >>> IF 1 c
fi
printf "${UL1}"; printf "${LILA}"
echo; echo "INSTALL AND SETUP"; sleep $myspeed
########################################## INSTALL & SETUP ===============================
printf "${NC}"; printf "${BLUE3}"
printf "${NC}"; printf "${BLUE3}"
sleep $myspeed
if [[ $RCLONE_INSTALL = "0" ]]
  then
  echo
  echo "[4] SETUP RCLONE"; echo; sleep $myspeed; echo
  ################################################### [4] SETUP RCLONE
  echo
  cd $HOME/start2
  echo PWD: $PWD
  echo; sleep $myspeed
  sudo apt install rclone -y
fi

if [[ $RCLONE_CONFIG = "0" || RCLONE_GD=0 = "0" ]]
  then
    printf "${NC}"; printf "${BLUE2}"
    echo; echo "SETUP GD ON RCLONE NOW PLEASE:"; printf "${NC}"; printf "${BLUE3}"; echo; sleep $myspeed
    rclone config
    rclonesize=$(rclone size ~/.config/rclone/rclone.conf --json | jq .bytes)
    printf "${RED}"; echo; echo rclone.conf size $rclonesize; echo
fi

printf "${LILA}"; printf "${UL1}"
echo; echo "[5] setup GPG encryption"; sleep $myspeed
#################################################################### [5] SETUP GPG 
echo
if [[ $GPG_INSTALLED = "0" ]]
then
  apt install gpg -y
else
  printf "${NC}"; printf "${GREEN}"
  echo GPG ALREADY INSTALLED -- CHECKING KEYS; echo; sleep $myspeed
  printf "${NC}"; printf "${BLUE3}"
fi

if [[ $GPG_KEYS = "0" ]]
then
  printf "${NC}"; printf "${BLUE2}"
  printf "PLEASE LOCATE RKO-FILES OR KEY.ASC  IN GD:SEC"; printf "${RED} -- SCRIPT WILL REMOVE AND DELETE THOSE FILES"; echo 
  printf "${NC}"; printf "${BLUE2}"
  echo "(echo 'gpg -a --export-secret-keys [key-id] >key.asc')"
  echo; printf "${YELLOW}"; echo BUTTON; printf "${BLUE3}"; read me
  
  mykey=$(rclone ls gd:sec --max-depth 1 --include="key.asc" | wc -l)
  if [[ $mykey > 1 ]] 
  then
    GPG_KEY_ASC=2
    printf "${NC}"; printf "${RED}"
    echo; echo "MORE THAN ONE key.asc FOUND. PLEASE PROVIDE ONLY ONE FILE ON GD: AND RESTART SCRIPT"; echo; sleep $myspeed
    printf "${YELLOW}"; echo BUTTON; printf "${BLUE3}"; read me
    printf "${NC}"; printf "${BLUE3}"
  elif [[ $mykey < 1 ]] 
  then
    GPG_KEY_ASC=0
    printf "${NC}"; printf "${RED}"
    echo; printf "key.asc NOT FOUND."; printf "${NC}"; printf "${BLUE2} LOOKING FOR rko-p FILES NOW."; echo; sleep $myspeed
    printf "${NC}"; printf "${BLUE3}"
  else
    GPG_KEY_ASC=1
  fi
  
  if [[ $GPG_KEY_ASC = "0" ]]
  then
    GPG_KEY_RKO=0
    myrko=$(rclone ls gd:sec --max-depth 1 --include="rko-p*.key" | wc -l)
    if [[ $myrko > 2 ]] 
    then
      GPG_KEY_RKO=3
      printf "${NC}"; printf "${RED}"
      printf "MORE THAN TWO rko-p*.key FILES FOUND."; printf "${BLUE2} PLEASE PROVIDE ONLY TWO FILES ON GD: AND RESTART SCRIPT"; echo; sleep $myspeed
      printf "${NC}"; printf "${BLUE3}"
      printf "${YELLOW}"; echo BUTTON; printf "${BLUE3}"; read me
    elif [[ $myrko = "1" ]]
    then
      GPG_KEY_RKO=2
      printf "${NC}"; printf "${RED}"
      printf "ONLY ONE rko-p*.key FILES FOUND."; printf "${NC}"; printf "${BLUE2} PLEASE PROVIDE ONLY TWO FILES ON GD: AND RESTART SCRIPT"; echo; sleep $myspeed
      printf "${NC}"; printf "${BLUE3}"
    elif [[ $myrko = "2" ]]
    then
      GPG_KEY_RKO=1
      printf "${NC}"; printf "${GREEN}"
      echo; echo "TWO rko-p FILES FOUND. STARTING GPG SETUP."
      printf "${NC}"; printf "${BLUE3}"
    fi
  fi
if [[ $GPG_KEY_RKO = "1" || $GPG_KEY_ASC = "1" ]]
then
  sleep $myspeed; echo; echo 'rclone copy gd:sec $HOME/tmpgpginstall  --include "rko-*" --include="key.asc" --max-depth 1 --fast-list --skip-links'; echo; sleep $myspeed
  rclone copy gd:sec $HOME/tmpgpginstall  --include "rko-*" --include="key.asc" --max-depth 1 --fast-list --skip-links; sleep $myspeed
  sudo chown abraxas: $HOME/tmpgpginstall -R
  sudo chmod 777 $HOME/tmpgpginstall -R
  cd $HOME/tmpgpginstall
  echo; echo "files downloaded:"; sleep $myspeed
  ls $HOME/tmpgpginstall
  echo
  printf "${NC}"; printf "${BLUE2}"
  echo; echo "IMPORTING GPG FILES"; echo; sleep $myspeed
  printf "${NC}"; printf "${BLUE3}"
  sudo gpg --import *
  printf "${YELLOW}"; echo BUTTON; printf "${BLUE3}" 60
  read -t 60 me 
  rm -rf $HOME/tmpgpginstall
  cd $HOME  
else
  printf "${NC}"; printf "${RED}"
  echo "NEITHER key.asc, NOR TWO rko-p*.key FILES FOUND. PLEASE PROVIDE ON GD: AND RESTART SCRIPT."
  printf "${NC}"; printf "${BLUE3}"
  read me
fi
fi

if [[ $RCLONE_COMPLETE != "1" ]]
then
      cd $HOME/start2
      printf "${YELLOW}"
      echo "starting decryption"; sleep $myspeed
      printf "${NC}"; printf "${BLUE3}"
      echo "sudo gpg --decrypt rclone_secure_setup2gd.sh.asc > rclonesetup.sh"; sleep $myspeed
      sudo gpg --decrypt rclone_secure_setup2gd.sh.asc > rclonesetup.sh; sleep $myspeed
      cat rclonesetup.sh
      sudo chmod +x *.sh
      printf "${NC}"; printf "${BLUE2}"
      echo; echo RCLONESETUP VIA SCRIPT STARTING; echo; sleep $myspeed
      printf "${NC}"; printf "${BLUE3}"
      ./rclonesetup.sh
      rm rclonesetup.sh
      sleep $myspeed
fi  

echo
printf "${LILA}"; printf "${UL1}"
echo; echo "[6] SOFTWARE INSTALL -- sudo apt-get install restic python3-pip -y"; echo; sleep $myspeed
printf "${NC}"; printf "${BLUE2}"
echo "sudo apt-get install restic python3-pip -y"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
sudo apt-get install restic python3-pip -y
###############################################################################  [6]
echo
printf "${LILA}"; printf "${UL1}"
echo "[7] SETUP SSH"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
###############################################################################  [7] SETUP SSH
sudo ssh -T git@github.com > sshresult
echo; echo "successfull? (y/N)"; echo; sleep $myspeed
read -n 1 sshresult 
if [[ $sshresult = "y" ]]
then
printf "${GREEN}"
  echo; echo $sshresult; echo
  echo; echo "SSH SETUP DONE - GITHUB ACCESS SUCCESSFULL"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
else
  printf "${RED}"
  echo; echo $sshresult; echo; printf "${LILA}"; printf "${UL1}"
  echo "STARTING SHH SETUP"; sleep $myspeed
  printf "${NC}"; printf "${BLUE3}"
  echo "rclone copy gdsec/supersec/sshkeys/id_rsa . -P"; sleep $myspeed
  echo
  rclone copy gdsec:supersec/sshkeys/id_rsa . -P
  echo
  sleep $myspeed
  #echo "gpg --decrypt id_rsa.asc > id_rsa"; sleep $myspeed
  #echo
  #printf "${YELLOW}"
  #echo "starting decryption"
  #printf "${NC}"; printf "${BLUE2}"; 
  #gpg --decrypt id_rsa.asc > id_rsa
  #rm id*.asc
  sudo mkdir $HOME/.ssh
  mv id_rsa $HOME/.ssh
  printf "${LILA}"; printf "${UL1}" 
  echo; echo "SETUP SSH FOLDER RIGHTS"; echo; sleep $myspeed
fi
printf "${NC}"; printf "${BLUE2}"
echo "STARTING SSH AGENT"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
eval `ssh-agent -s`
printf "${NC}"; printf "${BLUE2}"
echo; echo "SETTING FOLDER PERMISSIONS"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
sudo chmod 400 ~/.ssh/* -R
ssh-add ~/.ssh/id_rsa
sudo chmod 700 ~/.ssh
sudo chmod 644 ~/.ssh/authorized_keys
sudo chmod 644 ~/.ssh/known_hosts
sudo chmod 644 ~/.ssh/config &>/dev/null
sudo chmod 600 ~/.ssh/id_rsa
sudo chmod 644 ~/.ssh/id_rsa.pub
echo
printf "${LILA}"; printf "${UL1}"
echo "[9] RESTORE LATEST RESTIC SNAPSHOT"; sleep $myspeed; echo 
############################################################### RESTIC SNAPSHOT RESTORE [9]
echo; echo "do you want to perform this step? (y/n)"
echo; read -n 1 myrestic
if [[ $myrestic = "y" ]]
then
printf "${NC}"; printf "${BLUE3}"
cd $HOME
restic -r rclone:gd:restic snapshots > mysnapshots
cat mysnapshots
echo
printf "[1]"; my1=$(cat mysnapshots | tail -n7 | awk '{ print $1}' | sed '$ d' | sed '$ d' | sed -n 1p); echo $my1; echo
printf "[2]"; my2=$(cat mysnapshots | tail -n7 | awk '{ print $1}' | sed '$ d' | sed '$ d' | sed -n 2p); echo $my2; echo
printf "[3]"; my3=$(cat mysnapshots | tail -n7 | awk '{ print $1}' | sed '$ d' | sed '$ d' | sed -n 3p); echo $my3; echo
printf "[4]"; my4=$(cat mysnapshots | tail -n7 | awk '{ print $1}' | sed '$ d' | sed '$ d' | sed -n 4p); echo $my4; echo
printf "[5]"; my5=$(cat mysnapshots | tail -n7 | awk '{ print $1}' | sed '$ d' | sed '$ d' | sed -n 5p); echo $my5; echo
echo
printf "${NC}"; printf "${BLUE2}"
echo "COPY THE SNASPSHOT CODE OR CHOOSE FROM THE LAST 5:"
echo
printf ">>> "; printf "${NC}"; printf "${BLUE3}"; read mysnapshot
myrestore="n"
echo
printf "${NC}"; printf "${BLUE4}"
curl -s "https://maker.ifttt.com/trigger/tts/with/key/4q38KZvz7CwD5_QzdUZHq?value1=$mytext"
echo
echo "restic -r rclone:gd:restic restore $mysnapshot --target $PWD"; echo
printf "${NC}"; printf "${BLUE2}"
echo; printf "restore to $PWD, correct? (y/n) >>> ";
printf "${NC}"; printf "${BLUE3}" 
mytext="restic snapshot version can be selected now"
read -n 1 myrestore
myy=0
while [[ $myy = "0" ]]
do
if [[ $myrestore = "y" ]]
then
  sudo rm -rf /tmp-restic-restore
  sudo mkdir /tmp-restic-restore
  sudo chmod 777 /tmp-restic-restore -R 
  printf "${NC}"; printf "${BLUE2}"; echo;
  echo; echo "RESTIC TO TMP FOLDER /tmp-restic-restore"; echo; sleep $myspeed
  printf "${NC}"; printf "${YELLOW}"
  echo; restic -r rclone:gd:restic -v restore $mysnapshot --target /tmp-restic-restore
  ############### !!!!!!!!!!!!!! ###############################################
  echo
  printf "${NC}"; printf "${NC}"; printf "${BLUE2}"; 
  echo; printf "RCLONE TO $HOME"; printf "${RED} - THIS WILL OVERRIDE EXISTING FILES"; echo; sleep $myspeed
  echo; echo "restic copies these files:"; echo
  echo "rclone lsl /tmp-restic-restore --max-depth 2"
  printf "${NC}"; printf "${BLUE4}"
  printf "${NC}"; printf "${BLUE3}"
  echo 
  rclone lsl /tmp-restic-restore --max-depth 2
  mytext="snapshot downloaded, please approve continuation"; sleep $myspeed
  curl -s "https://maker.ifttt.com/trigger/tts/with/key/4q38KZvz7CwD5_QzdUZHq?value1=$mytext"
  echo "BUTTON START COPY (y/n)"; 
  
  ###### find username of restic snapshot for correct path usage: 
  myresticuserfolder=$(ls -d /tmp-restic-restore/*/*/bin | sed 's/\/bin.*//' | sed 's/.*tmprestigrestore\///')
  printf "${RED}"; echo myresticuserfolder $myresticuserfolder; printf "${NC}"; printf "${BLUE3}"; sleep 2
  printf "${NC}"; printf "${BLUE2}"; 
  echo; echo "rclone copy$myresticuserfolder $HOME/ -Pv"
  printf "${NC}"; printf "${BLUE4}"; echo "ENTER to START the transfer"
  echo; read me
  printf "${NC}"; printf "${BLUE3}"
  printf "${LILA}"; printf "${UL1}"
  echo; echo "/tmp-restic-restore/$myresticuserfolder:"; sleep $myspeed; sleep $myspeed; 
  printf "${NC}"; printf "${BLUE4}"
  ls $myresticuserfolder; sleep $myspeed; 
  printf "${NC}"; printf "${BLUE3}"
  mytext="please approve and select COPY MODE"
  curl -s "https://maker.ifttt.com/trigger/tts/with/key/4q38KZvz7CwD5_QzdUZHq?value1=$mytext"
  printf "${YELLOW}"; echo BUTTON; printf "${BLUE3}"; 
  sudo chmod 777 /tmp-restic-restore -R 
  #         --ignore-existing        Skip all files that exist on destination
  #   -u, --update      Skip files that are newer on the destination
  printf "${LILA}"; printf "${UL1}"
  echo; echo "COPY-MODE:"; echo; sleep $myspeed
  ################################################## COPY-MODE ###############################
  printf "${NC}"; printf "${LILA}"
  echo "[1] conservative: skip all files already existing"
  printf "${BLUE4} rclone copy $myresticuserfolder $HOME/ -Pv --update --ignore-existing --skip-links --fast-list
  "; echo
  printf "${NC}"; printf "${GREEN}"
  echo; echo "[2] moderate: only overwrite if newer:"
   printf "${BLUE4} rclone copy $myresticuserfolder $HOME/ -Pv --update --skip-links --fast-list
  "; echo
  printf "${NC}"; printf "${LILA}"
  echo; echo "[3] agressive: overwrite everything, dont delete"
   printf "${BLUE4} rclone ${RED} SYNC ${BLUE4} $myresticuserfolder $HOME/ -Pv --skip-links --fast-list
  "; echo
  echo;  printf "${BLUE2} >>>> "; read -n 1 mymode; echo; echo
  printf "${NC}"; printf "${BLUE3}"
  x=0
  sudo chmod 777 /tmp-restic-restore -R
  while [[ $x = "0" ]]
  do
    if [[ $mymode = "1" ]]
    then
      x=1
      echo "rclone copy $myresticuserfolder $HOME/ -Pv --update --ignore-existing --skip-links --fast-list"
      rclone copy $myresticuserfolder $HOME/ -Pv --update --ignore-existing --skip-links --fast-list
    elif [[ $mymode = "2" ]]
    then
      x=1
      echo "rclone copy $myresticuserfolder $HOME/ -Pv --update --skip-links --fast-list"
      rclone copy $myresticuserfolder $HOME/ -Pv --update --skip-links --fast-list
    elif [[ $mymode = "3" ]]
    then
      x=1
      echo "sudo rclone sync $myresticuserfolder/ $HOME/ -Pv --skip-links --fast-list"
     # rclone sync $HOME/ -Pv --skip-links --fast-list
      sudo rclone sync $myresticuserfolder/ $HOME/ -Pv --skip-links --fast-list
    else
      x=0
      printf "${RED}"
      echo "select [1] to [3]"; printf "${NC}"; printf "${BLUE3}"
    fi
  done

sudo chown $USER: $HOME -R
sudo chown $USER: $myresticuserfolder -R 

    # skip all, already existing:
  #rclone copy$myresticuserfolder $HOME/ -Pv --update --ignore-existing --skip-links --fast-list
  # only overwrite if newer:
  #rclone copy$myresticuserfolder $HOME/ -Pv --update --skip-links --fast-list

  #overwrite everything, dont delete: rclone copy$myresticuserfolder $HOME/ -Pv --skip-links --fast-list
  
  ############### !!!!!!!!!!!!!! ##################################
  echo
  myy=1
elif [[ $myrestore = "n" ]]
then
  echo "OK; n selected, I will exit"; sleep 3
  printf "${YELLOW}"; echo BUTTON; printf "${BLUE3}"
  read me
  myy=1
  exit
else
  echo "choose y or n"
  myy=0
fi
done

mytext="transfer finished. transfer finished"
curl -s "https://maker.ifttt.com/trigger/tts/with/key/4q38KZvz7CwD5_QzdUZHq?value1=$mytext"
printf "${LILA}"; printf "${UL1}"
fi
echo; echo; echo "[10] INSTALL KEEPASSXC"
########################################## KEEPASSXC [10]
printf "${NC}"; printf "${BLUE3}"
echo
mykeepass="n"
printf "${NC}"; printf "${BLUE2}"
echo "WANT TO INSTALL KEEPASSXC? (y/n)"
printf "${NC}"; printf "${BLUE3}"
read -n 1 -t 40 mykeepass

if [[ $mykeepass = "y" ]]; then
  sudo add-apt-repository ppa:phoerious/keepassxc -y
  sudo apt-get update
  sudo apt-get dist-upgrade -y
  #printf "${LILA}"
  sudo apt-get install -y keepassxc
fi
echo
printf "${LILA}"; printf "${UL1}"
echo "[11] SOFTWARE INSTALLATION"
################################################ [11] SOFTWARE INSTALLATION
printf "${NC}"; printf "${BLUE4}"
echo "INSTALL sudo apt-get install -y nano curl nfs-common xclip ssh-askpass jq taskwarrior android-tools-adb conky-all fd-find"
printf "${NC}"; printf "${BLUE3}"; echo
sudo apt-get install -y nano curl nfs-common xclip ssh-askpass jq taskwarrior android-tools-adb conky-all fd-find
echo
printf "${NC}"; printf "${BLUE3}"
myfonts="y"
printf "${LILA}"; printf "${UL1}"
echo "[12] WANT TO INSTALL FONTS? (y/n)"
##################################################### [12] FONTS
printf "${NC}"; printf "${BLUE3}"
read -n 1 -t 20 myfonts
if [[ $myfonts = "y" ]]; then
  #https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  curl -X POST -H "Content-Type: application/json" -d '{"myvar1":"foo","myvar2":"bar","myvar3":"foobar"}' "https://joinjoaomgcd.appspot.com/_ah/api/messaging/v1/sendPush?apikey=304c57b5ddbd4c10b03b76fa97d44559&deviceNames=razer,Chrome,ChromeRazer&text=play%20install%20this%20font&url=https%3A%2F%2Fgithub.com%2Fromkatv%2Fpowerlevel10k-media%2Fraw%2Fmaster%2FMesloLGS%2520NF%2520Regular.ttf&file=https%3A%2F%2Fgithub.com%2Fromkatv%2Fpowerlevel10k-media%2Fraw%2Fmaster%2FMesloLGS%2520NF%2520Regular.ttf&say=please%20install%20this%20font"
  sudo apt update && sudo apt install -y zsh fonts-powerline xz-utils wget  
  ###mlocate  -----> in tmu aufsetzen
  ###### https://github.com/suin/git-remind
  # sleep $myspeed1
fi
printf "${NC}"; printf "${LILA}"
echo; echo "[13] SETUP NTFY"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
######################################################################### [13] NTFY
curl -sSL https://archive.heckel.io/apt/pubkey.txt | sudo apt-key add -
sudo apt install apt-transport-https -y
sudo sh -c "echo 'deb [arch=amd64] https://archive.heckel.io/apt debian main' \
    > /etc/apt/sources.list.d/archive.heckel.io.list"  
sudo apt update
sudo apt install ntfy -y
sudo systemctl enable ntfy
sudo systemctl start ntfy

sudo mkdir /etc/systemd/system/ntfy-client.service.d
sudo sh -c 'cat > /etc/systemd/system/ntfy-client.service.d/override.conf' <<EOF
[Service]
User=$USER
Group=$USER
Environment="DISPLAY=:0" "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus"
EOF

sudo systemctl daemon-reload
sudo systemctl restart ntfy-client
printf "${NC}"; printf "${BLUE2}"
echo; echo "[14] PIP INSTALLS"; sleep $myspeed
############################################################## [14] PIP INSTALLS
printf "${NC}"; printf "${BLUE3}"
pip install apprise; sleep $myspeed
pip install paho-mqtt; sleep $myspeed
########################################################### [15] DOCKER
printf "${LILA}"; printf "${UL1}"
echo; echo "[15] INSTALL DOCKER"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
if [[ $HOST = *"LAPTOP"* ]]
then
  printf "${RED}"
  echo; echo "SKIPPING DOCKER INSTALLATION ON $HOST"; sleep $myspeed; printf "${NC}"; printf "${BLUE3}"
else 
  sudo apt-get install docker.io docker-compose -y
fi
#################################################### docker compose
echo
printf "${NC}"; printf "${BLUE2}"
echo; echo "[16] INSTALL BREW"; sleep $myspeed
################################################################# [16] BREW
printf "${NC}"; printf "${BLUE3}"
brewsetup="n"
printf "${NC}"; printf "${LILA}"
echo "START BREW SETUP?  (y/n)              --------------timeouut 20 n"
echo
printf "${NC}"; printf "${BLUE3}"
read -t 20 -n 1 brewsetup
echo
if [[ $brewsetup != "n" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/abrax/.zprofile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  sudo apt-get install build-essential -y
  brew install gcc  

printf "${LILA}"; printf "${UL1}"
echo "[17] INSTALL BREW BASED SOFTWARE"
printf "${NC}"; printf "${BLUE3}"
################################################################### [17] BREW BASED SOFTWARE
brew install thefuck
brew install gcalcli
brew install fzf
$(brew --prefix)/opt/fzf/install
fi
echo; echo "RESTIC:"; echo
restic snapshots
curl -d "restic snapshot read to choose" ntfy.sh/rkorkorkomain
echo; printf "choose the latest restcic snapshot for .zshrc: >>> "; read myrestic
restic restore $myrestic --target="$HOME" --include=".zshrc"
printf "${LILA}"; printf "${UL1}"; echo
echo "[18] AUTOREMOVE"; sleep $myspeed
################################################################# [18] CLEAN UP
echo; printf "${NC}"; printf "${BLUE3}"
rm -f $HOME/color.dat
sudo apt autoremove -y

#p $HOME/start2/dotfiles/.zshrc $HOME/
#cp $HOME/start2/dotfiles/.p10k.zsh $HOME/
#cp $HOME/start2/dotfiles/.taskrc $HOME/
#cp $HOME/start2/dotfiles/pcc $HOME/bin
#mv $HOME/start2/dotfiles/bin/* $HOME/bin/
echo
rm -rf $HOME/start
rm -rf $HME/start2
#rm -rf /tmp-restic-restore
echo
printf "${GREEN}"; printf "${UL1}"
echo DONE 
echo EXEC ZSH
printf "${NC}"
sleep $myspeed
echo
rm -rf .antigen
exec zsh
printf "${NC}"
