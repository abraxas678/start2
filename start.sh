#!/bin/bash
clear
myspeed="2"
echo "version 21"; sleep $myspeed
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
printf "${NC}"; printf "${BLUE2}"; 
clear; printf "DEFINE SPEED (default=2): "; read -n 1 myspeed
echo "speed [$myspeed]"
myspeed1=$(($myspeed-1))
echo "lower speed [$myspeed1]"; sleep 2
#delstart="n"
#echo; echo "DELETE FOLDER START? (y/n)"; echo
#read -n 1 -t 5 delstart
#if [[ $delstart = "y" ]]
#then
#  cd $HOME
#  rm -rf 
#fi
echo
printf "${BLUE1}"; printf "${UL1}"
echo; echo "[1] SYSTEM UPATE AND UPGRADE"; sleep $myspeed
##########################################  [1]
printf "${NC}"; printf "${BLUE3}"
echo "sudo apt-get update && sudo apt-get upgrade -y"
echo; sleep 4
sudo apt-get update && sudo apt-get upgrade -y
echo
printf "${BLUE1}"; printf "${UL1}"
echo "[2] INSTALL ZSH -- Oh-my-Zsh -- Antigen FRAMEWORK"; sleep $myspeed
#################################################################  [2]
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
printf "${BLUE1}"; printf "${UL1}"
echo "[3] CLONE REPOSITORY"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
###############################################################################  [3]
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
printf "${BLUE1}"; printf "${UL1}"
echo "CHECKING ENVIRONMENT CONDITION:"; echo; sleep $myspeed
printf "${NC}"; printf "${BLUE1}"; 
echo "GPG"; echo; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"

### >>> IF 1 O
if [[ $(which gpg) = *"/usr/bin/gpg"* ]]
then
  echo GPG_INSTALLED=1; sleep $myspeed1
  GPG_INSTALLED=1
### >>> IF 2 O
   if [[ $(gpg --list-keys) = *"amdamdes@mymails.cc"* ]]
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

printf "${BLUE1}"; 
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
 ### >>> IF 5 O
            if [[ $rclonesize -gt 6000 ]]
            then
              echo "RCLONE_COMPLETE=1"; sleep $myspeed1
              RCLONE_COMPLETE=1
 ### >>> IF 5 E
            else
              echo "RCLONE_COMPLETE=0"; sleep $myspeed1
              RCLONE_COMPLETE=0
 ### >>> IF 5 C
            fi 
 ### >>> IF 4 C
        fi
 ### >>> IF 3 E
    else
        echo "RCLONE_GD=0"; sleep $myspeed1
        RCLONE_GD=0
        echo; echo "SETUP GOOGLE DRIVE NOW"; echo; sleep $myspeed
        rclone config
 ### >>> IF 3 C
    fi
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

########################################## INSTALL & SETUP ===============================
printf "${UL1}"; printf "${BLUE1}"
echo; echo "INSTALL AND SETUP"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
echo
  echo GPG_INSTALLED=$GPG_INSTALLED; sleep $myspeed1
  echo GPG_KEYS=$GPG_KEYS; sleep $myspeed1
  echo GPG_KEY_ASC $GPG_KEY_ASC; sleep $myspeed1
  echo GPG_KEY_RKO $GPG_KEY_RKO; sleep $myspeed1
  echo
  echo RCLONE_INSTALL=$RCLONE_INSTALL; sleep $myspeed1
  echo CLONE_CONFIG=$RCLONE_CONFIG; sleep $myspeed1
  echo RCLONE_GD=$RCLONE_GD; sleep $myspeed1
  echo RCLONE_COMPLETE=$RCLONE_COMPLETE; sleep $myspeed1
echo
printf "${NC}"; printf "${BLUE3}"
sleep 3
echo "BUTTON timer 10"
read -t 10 me

if [[ $RCLONE_INSTALL = "0" ]]
  then
  echo
  echo "[4] SETUP RCLONE"; echo; sleep $myspeed; echo
  ############################################ [4]
  echo
  cd $HOME/start2
  echo
  echo PWD: $PWD
  echo; sleep $myspeed
  apt install rclone -y
fi

if [[ $RCLONE_CONFIG = "0" || RCLONE_GD=0 = "0" ]]
  then
    echo "SETUP GD NOW PLEASE:"; echo; sleep $myspeed
    rclone config
fi

printf "${BLUE1}"; printf "${UL1}"
echo; echo "[5] setup GPG encryption"; sleep $myspeed
#################################################################### SETUP GPG [5]
echo
printf "${NC}"; printf "${BLUE3}"
echo
  echo GPG_INSTALLED=$GPG_INSTALLED; sleep $myspeed1
  echo GPG_KEYS=$GPG_KEYS; sleep $myspeed1
  echo GPG_KEY_ASC $GPG_KEY_ASC; sleep $myspeed1
  echo GPG_KEY_RKO $GPG_KEY_RKO; sleep $myspeed1
  echo
  echo RCLONE_INSTALL=$RCLONE_INSTALL; sleep $myspeed1
  echo CLONE_CONFIG=$RCLONE_CONFIG; sleep $myspeed1
  echo RCLONE_GD=$RCLONE_GD; sleep $myspeed1
  echo RCLONE_COMPLETE=$RCLONE_COMPLETE; sleep $myspeed1
echo
printf "${NC}"; printf "${BLUE3}"

if [[ $GPG_INSTALLED = "0" ]]
then
  apt install gpg -y
else
  printf "${GREEN}"
  echo; echo GPG ALREADY INSTALLED; echo; sleep $myspeed
  printf "${NC}"; printf "${BLUE3}"
fi

if [[ $GPG_KEYS = "0" ]]
then
  printf "${NC}"; printf "${BLUE2}"
  printf "PLEASE LOCATE RKO-FILES OR KEY.ASC  IN GD:SEC"; printf "${RED} -- SCRIPT WILL REMOVE AND DELETE THOSE FILES"; echo 
  printf "${NC}"; printf "${BLUE2}"
  echo "(echo 'gpg -a --export-secret-keys [key-id] >key.asc')"
  echo; echo BUTTON; read me
  
  mykey=$(rclone ls gd:sec --max-depth 1 --include="key.asc" | wc -l)
  if [[ $mykey > 1 ]] 
  then
    GPG_KEY_ASC=2
    printf "${NC}"; printf "${RED}"
    echo; echo "MORE THAN ONE key.asc FOUND. PLEASE PROVIDE ONLY ONE FILE ON GD: AND RESTART SCRIPT"; echo; sleep $myspeed
    echo BUTTON; read me
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
      echo BUTTON; read me
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
  rclone copy gd:sec $HOME/tmpgpginstall  --include "rko-*" --include="key.asc" --max-depth 1 --fast-list --skip-links
  cd $HOME/tmpgpginstall
  echo; echo "files downloaded:"
  ls $HOME/tmpgpginstall
  echo
  printf "${NC}"; printf "${BLUE2}"
  echo; echo "IMPORTING GPG FILES"; echo; sleep $myspeed
  printf "${NC}"; printf "${BLUE3}"
  gpg --import *
  rm -rf $HOME/tmpgpginstall
  cd $HOME  
else
  printf "${NC}"; printf "${RED}"
  echo "NEITHER key.asc, NOR TWO rko-p*.key FILES FOUND. PLEASE PROVIDE ON GD: AND RESTART SCRIPT."
  printf "${NC}"; printf "${BLUE3}"
  read me
fi
fi

  echo GPG_INSTALLED=$GPG_INSTALLED; sleep $myspeed1
  echo GPG_KEYS=$GPG_KEYS; sleep $myspeed1
  echo GPG_KEY_ASC $GPG_KEY_ASC; sleep $myspeed1
  echo GPG_KEY_RKO $GPG_KEY_RKO; sleep $myspeed1
  echo
  echo RCLONE_INSTALL=$RCLONE_INSTALL; sleep $myspeed1
  echo CLONE_CONFIG=$RCLONE_CONFIG; sleep $myspeed1
  echo RCLONE_GD=$RCLONE_GD; sleep $myspeed1
  echo RCLONE_COMPLETE=$RCLONE_COMPLETE; sleep 3

if [[ $RCLONE_COMPLETE = "0" ]]
then
      cd $HOME/start2
      gpg --decrypt rclone_secure_setup2gd.sh.asc > rclonesetup.sh
      sudo chmod +x *.sh
      printf "${NC}"; printf "${BLUE2}"
      echo; echo RCLONESETUP VIA SCRIPT STATING; echo; sleep $myspeed
      printf "${NC}"; printf "${BLUE3}"
      ./rclonesetup.sh
      rm rclonesetup.sh
fi  

echo
printf "${BLUE1}"; printf "${UL1}"
echo; echo "[6] SOFTWARE INSTALL -- sudo apt-get install restic python3-pip -y"; echo; sleep $myspeed
printf "${NC}"; printf "${BLUE2}"
echo "sudo apt-get install restic python3-pip -y"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
sudo apt-get install restic python3-pip -y
###############################################################################  [6]
echo
printf "${BLUE1}"; printf "${UL1}"
echo "[7] SETUP SSH"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
###############################################################################  [7]
sshresult=$(ssh -T git@github.com)
if [[ $sshresult = *"successfully authenticated"* ]]
then
  echo; echo "SSH SETUP DONE - GITHUB ACCESS SUCCESSFULL"; sleep $myspeed
else
  echo STARTING SHH SETUP; sleep $myspeed
  echo "rclone copy gd:/sec/start/id_rsa.asc . -P"; sleep $myspeed
  echo
  rclone copy gd:/sec/start/id_rsa.asc . -P
  echo
  sleep $myspeed
  echo "gpg --decrypt id_rsa.asc > id_rsa"; sleep $myspeed
  echo
  gpg --decrypt id_rsa.asc > id_rsa
  rm id*.asc
  sudo mkdir $HOME/.ssh
  echo; echo "SETUP SHH FOLDER RIGHTS"; echo; sleep $myspeed
  #  DEFINE USERNAME
  echo; echo; echo "CURRENT USER DETAILS:"; echo;
  echo $USER; echo; id
  echo; printf "USERNAME TO USE: >>>"; read myuser
  echo; echo "USING $myuser"; echo; echo BUTTON; read me
  echo; echo "sudo chown $myuser:100 $HOME -R"
  echo "sudo chmod 700 -R $HOME"
  sudo chown $myuser:100 $HOME -R
  sudo chmod 700 -R $HOME
  mv id_rsa $HOME/.ssh
fi
echo; echo "STARTING SSH AGENT"; echo; sleep $myspeed
eval `ssh-agent -s`
echo; echo "SETTING FOLDER PERMISSIONS"; echo; sleep $myspeed
sudo chmod 400 ~/.ssh/* -R
ssh-add ~/.ssh/id_rsa
sudo chmod 700 ~/.ssh
sudo chmod 644 ~/.ssh/authorized_keys
sudo chmod 644 ~/.ssh/known_hosts
sudo chmod 644 ~/.ssh/config
sudo chmod 600 ~/.ssh/id_rsa
sudo chmod 644 ~/.ssh/id_rsa.pub
echo
printf "${BLUE1}"; printf "${UL1}"
echo "[9] RESTORE LATEST RESTIC SNAPSHOT"; sleep $myspeed; echo 
printf "${NC}"; printf "${BLUE3}"
######################################################### [9]
restic -r rclone:gd:restic snapshots
echo
printf "${NC}"; printf "${BLUE2}"
echo "Which snapshot do you wish to restore?"
echo
printf "${NC}"; printf "${BLUE3}"
printf ">>> "; read mysnapshot
myrestore="n"
echo
echo "restic -r rclone:gd:restic restore $mysnapshot --target $PWD"; echo
echo; echo "restore to $PWD, correct? (y/n)"; 
read -n 1 myrestore
if [[ $myrestore = "y" ]]
then
  rm -rf $HOME/tmprestigrestore
  echo; echo "RESTIC TO TMP FOLDER"; echo; sleep $myspeed
  restic -r rclone:gd:restic restore $mysnapshot --target $HOME/tmprestigrestore
  printf "${NC}"; printf "${RED}"
  echo; echo "RCLONE TO $HOME - THIS WILL OVERRIDE EXISTING FILES"; echo; sleep $myspeed
  echo BUTTON; read me
  printf "${NC}"; printf "${BLUE3}"
  rclone copy $HOME/tmprestigrestore/ $HOME/ -Pv
  echo
fi
#################################################################  ab hier das script weiter machen
########################################## KEEPASSXC
printf "${BLUE1}"; printf "${UL1}"
echo; echo; echo "INSTALL KEEPASSXC"
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
  #printf "${BLUE1}"
  sudo apt-get install -y keepassxc
fi

printf "${NC}"; printf "${BLUE2}"
echo; echo "INSTALL sudo apt-get install -y nano curl nfs-common xclip ssh-askpass jq taskwarrior android-tools-adb conky-all fd-find"
sudo apt-get install -y nano curl nfs-common xclip ssh-askpass jq taskwarrior android-tools-adb conky-all fd-find
echo
printf "${NC}"; printf "${BLUE3}"
myfonts="n"
printf "${BLUE1}"; printf "${UL1}"
echo "WANT TO INSTALL FONTS? (y/n)"
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
printf "${NC}"; printf "${BLUE2}"
echo; echo "SETUP NTFY"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
###################################################################################### NTFY
curl -sSL https://archive.heckel.io/apt/pubkey.txt | sudo apt-key add -
sudo apt install apt-transport-https
sudo sh -c "echo 'deb [arch=amd64] https://archive.heckel.io/apt debian main' \
    > /etc/apt/sources.list.d/archive.heckel.io.list"  
sudo apt update
sudo apt install ntfy
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
##################################################################################### PIP INSTALLS
echo; echo "PIP INSTALLS"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
pip install apprise
pip install paho-mqtt
############################
##################################################################################### DOCKER
printf "${BLUE1}"; printf "${UL1}"
echo; echo "INSTALL DOCKER"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
apt-get install docker.io docker-compose -y
############################
echo
printf "${NC}"; printf "${BLUE2}"
echo; echo "INSTALL BREW"; sleep $myspeed
printf "${NC}"; printf "${BLUE3}"
brewsetup="n"
printf "${NC}"; printf "${BLUE1}"
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
fi

brew install fd
brew install fzf
brew install thefuck
$(brew --prefix)/opt/fzf/install
brew install gcalcli
echo
echo AUTOREMOVE
echo
rm -f $HOME/color.dat
sudo apt autoremove -y

cp $HOME/start2/dotfiles/.zshrc $HOME/
cp $HOME/start2/dotfiles/.p10k.zsh $HOME/
cp $HOME/start2/dotfiles/.taskrc $HOME/
cp $HOME/start2/dotfiles/pcc $HOME/bin
mv $HOME/start2/dotfiles/bin/* $HOME/bin/
echo
rm -rf $HOME/start
rm -rf $HME/start2
echo
echo EXEC ZSH
sleep $myspeed
echo
exec zsh
printf "${GREEN}"; printf "${UL1}"
echo DONE 
printf "${NC}"
