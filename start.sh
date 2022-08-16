#!/bin/bash 
# $1 = # of seconds
# $@ = What to print after "Waiting n seconds"
pueue clean -g system-setup >/dev/null 2>/dev/null 
pueue clean -g system-setup >/dev/null 2>/dev/null 
################################## FUNCTIONS ###########################################
countdown() {
  secs=$1
  shift
  msg=$@
  while [ $secs -gt 0 ]
  do
    printf "\r\033[K %.d $msg" $((secs--))
#    printf "\r\033[KWaiting %.d seconds $msg" $((secs--))
    sleep 1
  done
  echo
}

pp() {
  rich -u --print Pueue
  rich -a rounded --print "$( \
  rich -a rounded --print "$(pueue status | grep Success |awk '{ print $2,"  " $3,"  " $5," " $6 }' |sed 's/Success/\[green\]Success\[\/green\]/')"
  rich -a rounded --print "$(pueue status | grep Queue |awk '{ print $2,"  " $3,"  " $5," " $6 }' |sed 's/Queue/\[Yellow\]Queue\[\/Yellow\]/')"
  rich -a rounded --print "$(pueue status | grep Failure |awk '{ print $2,"  " $3,"  " $5," " $6 }' |sed 's/Failure/\[red\]Failure\[\/red\]/')" )"
}

pueue-init() {
  x=0
  rm -f pueuestatus.txt
  while [[ $x -eq 0 ]]; do
  echo "PUEUE INIT"
  countdown 3
  export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
  /home/linuxbrew/.linuxbrew/bin/pueue status >> pueuestatus.txt 2>> pueuestatus.txt
   /home/linuxbrew/.linuxbrew/bin/pueue status
  [[ $(cat pueuestatus.txt) = *"Failed to initialize client"* ]] &&  /home/linuxbrew/.linuxbrew/bin/pueued -d && sleep 2 &&  /home/linuxbrew/.linuxbrew/bin/pueue status
  [[ $(cat pueuestatus.txt) = *"Permission denied"* ]] && sudo chown -R abraxas: /run/user && sudo chmod +x /home/linuxbrew/.linuxbrew/bin/pueue &&  /home/linuxbrew/.linuxbrew/bin/pueued -d && sleep 2 &&  /home/linuxbrew/.linuxbrew/bin/pueue status
  [[ $(cat pueuestatus.txt | head -n1) = *"Group"* ]] && x=1
  sleep 1
  done
  rm -f pueuestatus.txt
}

trenner() {
  /home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style blue -u --print "$@"
}
################################## SCRIPT ###########################################
clear
cd $HOME
ts=$(date +"%s")
myspeed="0.5"

#######################################################
echo "version 199"; sleep $myspeed
#######################################################

cd $HOME
echo "CURRENT USER: $USER" 
read -t 1 me
[[ $USER != "abraxas" ]] && [[ ! $(id -u abraxas) ]] && sudo adduser abraxas && sudo passwd abraxas && sudo usermod -aG sudo abraxas && su abraxas
[[ $USER != "abraxas" ]] && su abraxas
echo "CURRENT USER: $USER"
[[ $USER != "abraxas" ]] && echo BUTTON && read me || echo button2 && read -t 2 me

ts=$(date +"%s")
if [[ -d start2 ]]
then
  mv start2 start2-backup-$ts
fi
export PATH=$PATH:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin:/usr/local/sbin:/usr/local/bin:/usr/path:/volume2/docker/utils/path:$HOME/.local/bin:$HOME/bin:/home/markus/.cargo/bin:/home/abraxas/.cargo/bin:/home/abraxas/.local/bin/:/home/abraxas/.cargo/bin:/home/linuxbrew/.linuxbrew/bin:/volume1/homes/abraxas678/bin:/usr/local/bin:$PATH

echo; echo "CLONE START2 REPOSITORY"; sleep $myspeed
sudo apt-get install git -y
git config --global user.name abraxas678
git config --global user.email abraxas678@gmail.com
sleep $myspeed
sudo ls >/dev/null
cd $HOME
git clone https://github.com/abraxas678/start2.git; echo
source $HOME/start2/color.dat
source $HOME/start2/path.dat

###   df /home grösser 50GB?
chmod +x $HOME/start2/*.sh
[[ $(df -h /home  |awk '{ print $2 }' |tail -n1 | sed 's/G//' | sed 's/\./,/') -lt 15 ]] && /bin/bash $HOME/start2/new-disk.sh

echo; printf "DEFINE SPEED (default=2): "; read -n 1 -t 5 myspeed; echo
echo "speed [$myspeed]"
[[ $(echo $RESTIC_PASSWORD | md5sum) != *"81a8c96e402c1647469856787d5c8503"* ]] && echo && printf "restic password: >>> " && read -n 4 myresticpw && export RESTIC_PASSWORD=$myresticpw
export RESTIC_REPOSITORY=rclone:gd:restic
echo; echo "RC PW:"; read rcpw 
echo $rcpw > ~/rcpw
sudo apt install lsof -y
curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl start tailscaled
sudo tailscale up
echo; echo "sudo tailscale file cp ~/.config/rclone/rclone.conf $(hostname):"
echo;
countdown 10
[[ $(/home/linuxbrew/.linuxbrew/bin/pueue -V) = *"Pueue client"* ]] && MY_PUEUE_INST=1 || MY_PUEUE_INST=0
echo; echo MY_PUEUE_INST $MY_PUEUE_INST
countdown 3
[[ $MY_PUEUE_INST -eq 1 ]] && pueue-init
echo; echo "sudo apt-get update && sudo apt-get upgrade -y"; 
countdown 3 
[[ $MY_PUEUE_INST -eq 1 ]] && /home/linuxbrew/.linuxbrew/bin/pueue parallel 1 -g system-setup
[[ $MY_PUEUE_INST -eq 1 ]] && /home/linuxbrew/.linuxbrew/bin/pueue start -g system-setup
[[ $MY_PUEUE_INST -eq 1 ]] && /home/linuxbrew/.linuxbrew/bin/pueue add -g system-setup -- sudo apt-get update && sudo apt-get upgrade -y ||  sudo apt-get update && sudo apt-get upgrade -y
echo; countdown 2
[[ $MY_PUEUE_INST -eq 1 ]] && /home/linuxbrew/.linuxbrew/bin/pueue add -g system-setup -- sudo apt-get install python3-pip firefox-esr -y || sudo apt-get install python3-pip firefox-esr -y
echo; countdown 2
echo; echo "BREW SETUP"; echo
countdown 3
  
  export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo; countdown 3
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shelle /home/linuxbrew/.linuxbrew/binnv)"' >> /home/abrax/.zprofile
  [[ $MY_PUEUE_INST -eq 1 ]] && /home/linuxbrew/.linuxbrew/bin/pueue add -g system-setup -- eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" || eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  [[ $MY_PUEUE_INST -eq 1 ]] && /home/linuxbrew/.linuxbrew/bin/pueue add -g system-setup -- sudo apt-get install build-essential -y || sudo apt-get install build-essential -y
  export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
  [[ $MY_PUEUE_INST -eq 1 ]] && /home/linuxbrew/.linuxbrew/bin/pueue add -g system-setup -- brew install gcc || brew install gcc
  
echo; echo "PUEUE INSTALL"
  countdown 3
  brew install pueue
  echo; echo "INSTALL RICH-CLI"
  brew install rich
  export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
  /home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style blue --print "rich installed" -u
  countdown 3
  sudo chown -R abraxas: /run/user
  sudo chown -R abraxas: /home
  sudo chmod +x /home/abraxas/.cargo/bin/pueue
  sudo chmod +x /home/abraxas/.cargo/bin/pueued
  sudo chmod +x /home/linuxbrew/.linuxbrew/bin/pueue
  sudo chmod +x /home/linuxbrew/.linuxbrew/bin/pueued
  source $HOME/start2/path.dat
  echo; echo "pueued -d"
  /home/linuxbrew/.linuxbrew/bin/pueued -d
  /home/linuxbrew/.linuxbrew/bin/pueue start
  /home/linuxbrew/.linuxbrew/bin/pueue

x=0
rm -f pueuestatus.txt
while [[ $x -eq 0 ]]; do
echo "PUEUE INIT"
countdown 3
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"
/home/linuxbrew/.linuxbrew/bin/pueue status >>pueuestatus.txt 2>>pueuestatus.txt
[[ $(cat pueuestatus.txt) = *"Failed to initialize client"* ]] &&  /home/linuxbrew/.linuxbrew/bin/pueued -d && sleep 2 &&  /home/linuxbrew/.linuxbrew/bin/pueue status
[[ $(cat pueuestatus.txt) = *"Permission denied"* ]] && sudo chown -R abraxas: /run/user && sudo chmod +x /home/linuxbrew/.linuxbrew/bin/pueue &&  /home/linuxbrew/.linuxbrew/bin/pueued -d && sleep 2 &&  /home/linuxbrew/.linuxbrew/bin/pueue status
[[ $(cat pueuestatus.txt) = *"Group"* ]] && x=1
printf pueuestatus.txt; cat pueuestatus.txt
sleep 1
done
rm -f pueuestatus.txt
/home/linuxbrew/.linuxbrew/bin/pueue status
countdown 2
  ######################################## BREW BASED SOFTWARE ########################################
  /home/linuxbrew/.linuxbrew/bin/rich --panel rounded ---panel-style blue -style green --print "INSTALL BREW BASED SOFTWARE"
  countdown 2
  pueue group add system-setup
  pueue parallel 1 -g system-setup 
  pueue add -g system-setup -- brew install thefuck
  pueue add -g system-setup -- brew install gcalcli
  pueue add -g system-setup -- brew install fzf
  pueue add -g system-setup --  brew install just 
  pueue add -g system-setup -- 'yes | $(brew --prefix)/opt/fzf/install'
  echo; pueue status -g system-setup 
  countdown 5
 /home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style blue -u
################################################################################################

  echo "$EDITOR=/usr/bin/nano" >> $HOME/.bashrc
  source $HOME/.bashrc
  /home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style blue --title tmux tmuxiator --print "$(sudo apt-get install -y tmux tmuxinator)" 
  ############  >>>>>>>>>>>>>>>>>>>>>>>   tmux new-session -d -s "Start2" $HOME/main_script.sh
  /home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style blue --print "[2] INSTALL ZSH -- Oh-my-Zsh -- Antigen FRAMEWORK"; sleep $myspeed
  #############################################  [2] INSTALL ZSH -- Oh-my-Zsh -- Antigen FRAMEWORK
  /home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style blue --title "zsh php nodejs npm plocate" --print "$(pueue add -g system-setup --  sudo apt install -y zsh php nodejs npm firefox-esr plocate)"
  pueue add -g system-setup -- 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
  pueue add -g system-setup -- 'curl -L git.io/antigen > $HOME/antigen.zsh'
countdown 5
/home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style blue --title unzip jq --print "$(sudo apt-get install unzip jq -y)"

trenner
/home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style green --panel-style blue --print "CHECKING ENVIRONMENT CONDITION:"; sleep $myspeed
/home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style green --panel-style blue  --print "GPG"; echo; sleep $myspeed
trenner
countdown 5
### >>> IF 1 O
if [[ $(which gpg) = *"/usr/bin/gpg"* ]]
then
  echo GPG_INSTALLED=1; sleep $myspeed1
  GPG_INSTALLED=1
### >>> IF 2 O
mykeycheck=$(sudo gpg --list-secret-keys)
echo "MYKEYCHECK $mykeycheck"
  if [[ $mykeycheck -gt "0" ]]
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
trenner
/home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style green --panel-style blue --print RCLONE
/home/linuxbrew/.linuxbrew/bin/rich -u --print "tailscale get file"
echo; sudo tailscale file get ~/.config/rclone/
countdown 5
rclone copy df: $HOME --max-depth 1 --include=".zsh.env" -P --update --password-command="cat /home/abraxas/rcpw"
source ~/.zsh.env
/home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style blue --print "INSTALL AGE"
/home/linuxbrew/.linuxbrew/bin/rich -u --print "myfilter.txt copy"
rclone copy gd:dotfiles/myfilter.txt $HOME -P --update --password-command="cat /home/abraxas/rcpw"
rclone copy gd:dotfiles/bin/ $HOME/bin -P --include="install-age.sh" --update --password-command="cat /home/abraxas/rcpw"
/home/linuxbrew/.linuxbrew/bin/rich -u --print "bin copy"
/home/linuxbrew/.linuxbrew/bin/pueue add -g system-setup -- rclone copy gd:dotfiles/bin/ $HOME/bin -P --update --password-command="cat /home/abraxas/rcpw"
sudo chmod +x $HOME/bin/*
/home/linuxbrew/.linuxbrew/bin/rich -u --print "INSTALL AGE"
/bin/bash $HOME/bin/install-age.sh
/home/linuxbrew/.linuxbrew/bin/rich -u --print ".config copy"
rclone copy df:.config ~/.config -P --update --password-command="cat /home/abraxas/rcpw"
/home/linuxbrew/.linuxbrew/bin/rich -u --print "dotfiles --max-depth 1 copy"
rclone copy df: $HOME -P --max-depth 1 --update --password-command="cat /home/abraxas/rcpw"
/home/linuxbrew/.linuxbrew/bin/rich -u --print ".ssh copy"
rclone copy df:.ssh ~/.ssh -P --update --password-command="cat /home/abraxas/rcpw"
rm -f ~/rcpw
source $HOME/.zsh.env
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

trenner
/home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style green --panel-style blue --print "INSTALL AND SETUP RCLONE"
countdown 3
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
  #sudo apt install rclone -y
  curl https://rclone.org/install.sh | sudo bash
fi

if [[ $RCLONE_CONFIG = "0" || RCLONE_GD = "0" ]]
  then
    printf "${NC}"; printf "${BLUE2}"
    echo; echo "SETUP GD ON RCLONE NOW PLEASE:"; printf "${NC}"; printf "${BLUE3}"; echo; sleep $myspeed
    rclone config
    rclonesize=$(rclone size ~/.config/rclone/rclone.conf --json | jq .bytes)
    printf "${RED}"; echo; echo rclone.conf size $rclonesize; echo
fi

printf "${LILA}"; printf "${UL1}"
/home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style green --panel-style blue --print "[5] setup GPG encryption"
countdown 2
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
  echo; printf "${YELLOW}"; echo BUTTON20; printf "${BLUE3}"; read -t 20 me
  
  mykey=$(rclone ls gd:sec --max-depth 1 --include="key.asc" | wc -l)
  if [[ $mykey > 1 ]] 
  then
    GPG_KEY_ASC=2
    printf "${NC}"; printf "${RED}"
    echo; echo "MORE THAN ONE key.asc FOUND. PLEASE PROVIDE ONLY ONE FILE ON GD: AND RESTART SCRIPT"; echo; sleep $myspeed
    printf "${YELLOW}"; echo BUTTON; printf "${BLUE3}"; read -t 10 me
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
  echo GPG_KEY_RKO $GPG_KEY_RKO GPG_KEY_ASC $GPG_KEY_ASC
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
  printf "${YELLOW}"; echo BUTTON60; printf "${BLUE3}" 60
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
      rclone copy ./rclonesetup.sh gdsec: -P
      rm rclonesetup.sh
      sleep $myspeed
fi  

trenner

rclone copy gd:dotfiles/.bashrc $HOME -P
rclone copy gd:dotfiles/.zshrc $HOME -P
rclone copy gd:dotfiles/.p10k.zsh $HOME -P

trenner SOFTWARE INSTALL
pueue add -g system-setup -- sudo apt-get install restic SS-y
###############################################################################  [6]
echo
trenner SSH SETUP
###############################################################################  [7] SETUP SSH
/home/linuxbrew/.linuxbrew/bin/rich -u --panel rounded --title "sudo ssh -T git@github.com" --print "$(sudo ssh -T git@github.com)"
#sudo ssh -T git@github.com
trenner "successfull? (y/N)"
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
  echo "rclone copy gd:sec/supersec/sshkeys/id_rsa . -P"; sleep $myspeed
  echo
  rclone copy gd:sec/supersec/sshkeys/id_rsa . -P
  echo
  sleep $myspeed
  #echo "gpg --decrypt id_rsa.asc > id_rsa"; sleep $myspeed
  #echo
  #printf "${YELLOW}"
  #echo "starting decryption"
  #printf "${NC}"; printf "${BLUE2}"; 
  #gpg --decrypt id_rsa.asc > id_rsa
  #rm id*.asc
fi
fi
  sudo mkdir $HOME/.ssh
  mv id_rsa $HOME/.ssh
  trenner "SETUP SSH FOLDER RIGHTS"
  echo; sleep $myspeed

echo "pueue add -g system-setup --rclone copy gd:dotfiles/bin $HOME/bin --update -L -P"
pueue add -g system-setup -- rclone copy gd:dotfiles/bin $HOME/bin --update -L -P
printf "${NC}"; printf "${BLUE2}"
pueue add -g system-setup --rclone copy gd:dotfiles $HOME --max-depth 1 --update -L -P"
G SSH AGENT"; sleep $myspeed
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
#printf "${LILA}"; printf "${UL1}"
#echo "[9] RESTORE LATEST RESTIC SNAPSHOT"; sleep $myspeed; echo 
############################################################### RESTIC SNAPSHOT RESTORE [9]
#echo; echo "do you want to perform this step? (y/n)"
#echo; read -n 1 myrestic
#if [[ $myrestic = "y" ]]
#then
#printf "${NC}"; printf "${BLUE3}"
#cd $HOME
#restic -r rclone:gd:restic snapshots > mysnapshots
#cat mysnapshots
#echo
#printf "[1]"; my1=$(cat mysnapshots | tail -n7 | awk '{ print $1}' | sed '$ d' | sed '$ d' | sed -n 1p); echo $my1; echo
#printf "[2]"; my2=$(cat mysnapshots | tail -n7 | awk '{ print $1}' | sed '$ d' | sed '$ d' | sed -n 2p); echo $my2; echo
#printf "[3]"; my3=$(cat mysnapshots | tail -n7 | awk '{ print $1}' | sed '$ d' | sed '$ d' | sed -n 3p); echo $my3; echo
#printf "[4]"; my4=$(cat mysnapshots | tail -n7 | awk '{ print $1}' | sed '$ d' | sed '$ d' | sed -n 4p); echo $my4; echo
#printf "[5]"; my5=$(cat mysnapshots | tail -n7 | awk '{ print $1}' | sed '$ d' | sed '$ d' | sed -n 5p); echo $my5; echo
#echo
#printf "${NC}"; printf "${BLUE2}"
#echo "COPY THE SNASPSHOT CODE OR CHOOSE FROM THE LAST 5:"
#echo
#printf ">>> "; printf "${NC}"; printf "${BLUE3}"; read mysnapshot
#myrestore="n"
#echo
#printf "${NC}"; printf "${BLUE4}"
#curl -s "https://maker.ifttt.com/trigger/tts/with/key/4q38KZvz7CwD5_QzdUZHq?value1=$mytext"
#echo
#echo "restic -r rclone:gd:restic restore $mysnapshot --target $PWD"; echo
#printf "${NC}"; printf "${BLUE2}"
#echo; printf "restore to $PWD, correct? (y/n) >>> ";
#printf "${NC}"; printf "${BLUE3}" 
#mytext="restic snapshot version can be selected now"
#read -n 1 myrestore
#myy=0
#while [[ $myy = "0" ]]
#do
#if [[ $myrestore = "y" ]]
#then
#  sudo rm -rf /tmp-restic-restore
#  sudo mkdir /tmp-restic-restore
#  sudo chmod 777 /tmp-restic-restore -R 
#  printf "${NC}"; printf "${BLUE2}"; echo;
#  echo; echo "RESTIC TO TMP FOLDER /tmp-restic-restore"; echo; sleep $myspeed
#  printf "${NC}"; printf "${YELLOW}"
#  echo; restic -r rclone:gd:restic -v restore $mysnapshot --target /tmp-restic-restore
  ############### !!!!!!!!!!!!!! ###############################################
#  echo
#  printf "${NC}"; printf "${NC}"; printf "${BLUE2}"; 
#  echo; printf "RCLONE TO $HOME"; printf "${RED} - THIS WILL OVERRIDE EXISTING FILES"; echo; sleep $myspeed
#  echo; echo "restic copies these files:"; echo
#  echo "rclone lsl /tmp-restic-restore --max-depth 2"
#  printf "${NC}"; printf "${BLUE4}"
#  printf "${NC}"; printf "${BLUE3}"
#  echo 
#  rclone lsl /tmp-restic-restore --max-depth 2
#  mytext="snapshot downloaded, please approve continuation"; sleep $myspeed
#  curl -s "https://maker.ifttt.com/trigger/tts/with/key/4q38KZvz7CwD5_QzdUZHq?value1=$mytext"
#  echo "BUTTON START COPY (y/n)"; 
  
  ###### find username of restic snapshot for correct path usage: 
#  myresticuserfolder=$(ls -d /tmp-restic-restore/*/*/bin | sed 's/\/bin.*//' | sed 's/.*tmprestigrestore\///')
#  printf "${RED}"; echo myresticuserfolder $myresticuserfolder; printf "${NC}"; printf "${BLUE3}"; sleep 2
#  printf "${NC}"; printf "${BLUE2}"; 
#  echo; echo "rclone copy$myresticuserfolder $HOME/ -Pv"
#  printf "${NC}"; printf "${BLUE4}"; echo "ENTER to START the transfer"
#  echo; read me
#  printf "${NC}"; printf "${BLUE3}"
#  printf "${LILA}"; printf "${UL1}"
#  echo; echo "/tmp-restic-restore/$myresticuserfolder:"; sleep $myspeed; sleep $myspeed; 
#  printf "${NC}"; printf "${BLUE4}"
#  ls $myresticuserfolder; sleep $myspeed; 
#  printf "${NC}"; printf "${BLUE3}"
#  mytext="please approve and select COPY MODE"
#  curl -s "https://maker.ifttt.com/trigger/tts/with/key/4q38KZvz7CwD5_QzdUZHq?value1=$mytext"
#  printf "${YELLOW}"; echo BUTTON; printf "${BLUE3}"; 
#  sudo chmod 777 /tmp-restic-restore -R 
  #         --ignore-existing        Skip all files that exist on destination
  #   -u, --update      Skip files that are newer on the destination
#  printf "${LILA}"; printf "${UL1}"
#  echo; echo "COPY-MODE:"; echo; sleep $myspeed
#  ################################################## COPY-MODE ###############################
#  printf "${NC}"; printf "${LILA}"
#  echo "[1] conservative: skip all files already existing"
#  printf "${BLUE4} rclone copy $myresticuserfolder $HOME/ -Pv --update --ignore-existing --skip-links --fast-list
#  "; echo
#  printf "${NC}"; printf "${GREEN}"
#  echo; echo "[2] moderate: only overwrite if newer:"
#   printf "${BLUE4} rclone copy $myresticuserfolder $HOME/ -Pv --update --skip-links --fast-list
#  "; echo
#  printf "${NC}"; printf "${LILA}"
#  echo; echo "[3] agressive: overwrite everything, dont delete"
#   printf "${BLUE4} rclone ${RED} SYNC ${BLUE4} $myresticuserfolder $HOME/ -Pv --skip-links --fast-list
#  "; echo
#  echo;  printf "${BLUE2} >>>> "; read -n 1 mymode; echo; echo
#  printf "${NC}"; printf "${BLUE3}"
#  x=0
#  sudo chmod 777 /tmp-restic-restore -R
#  while [[ $x = "0" ]]
#  do
#    if [[ $mymode = "1" ]]
#    then
#      x=1
#      echo "rclone copy $myresticuserfolder $HOME/ -Pv --update --ignore-existing --skip-links --fast-list"
#      rclone copy $myresticuserfolder $HOME/ -Pv --update --ignore-existing --skip-links --fast-list
#    elif [[ $mymode = "2" ]]
#    then
#      x=1
#      echo "rclone copy $myresticuserfolder $HOME/ -Pv --update --skip-links --fast-list"
#      rclone copy $myresticuserfolder $HOME/ -Pv --update --skip-links --fast-list
#    elif [[ $mymode = "3" ]]
#    then
#      x=1
#      echo "sudo rclone sync $myresticuserfolder/ $HOME/ -Pv --skip-links --fast-list"
#     # rclone sync $HOME/ -Pv --skip-links --fast-list
#      sudo rclone sync $myresticuserfolder/ $HOME/ -Pv --skip-links --fast-list
#    else
#      x=0
#      printf "${RED}"
#      echo "select [1] to [3]"; printf "${NC}"; printf "${BLUE3}"
#    fi
#  done

#sudo chown $USER: $HOME -R
#sudo chown $USER: $myresticuserfolder -R 

    # skip all, already existing:
  #rclone copy$myresticuserfolder $HOME/ -Pv --update --ignore-existing --skip-links --fast-list
  # only overwrite if newer:
  #rclone copy$myresticuserfolder $HOME/ -Pv --update --skip-links --fast-list

  #overwrite everything, dont delete: rclone copy$myresticuserfolder $HOME/ -Pv --skip-links --fast-list
  
  ############### !!!!!!!!!!!!!! ##################################
#  echo
#  myy=1
#elif [[ $myrestore = "n" ]]
#then
#  echo "OK; n selected, I will exit"; sleep 3
#  printf "${YELLOW}"; echo BUTTON; printf "${BLUE3}"
#  read me

#  myy=1
#  exit
#else
#  echo "choose y or n"
#  myy=0
#fi
#done

#mytext="transfer finished. transfer finished"
#curl -s "https://maker.ifttt.com/trigger/tts/with/key/4q38KZvz7CwD5_QzdUZHq?value1=$mytext"
#printf "${LILA}"; printf "${UL1}"
#fi
if [[ $mysnas = "0" ]]; then
echo; echo; echo "[10] INSTALL KEEPASSXC"
########################################## KEEPASSXC [10]
printf "${NC}"; printf "${BLUE3}"
echo
mykeepass="n"
printf "${NC}"; printf "${BLUE2}"
echo "WANT TO INSTALL KEEPASSXC? (y/n)"
printf "${NC}"; printf "${BLUE3}"
mykeepass="y"
echo BUTTON10
read -n 1 -t 10 mykeepass

if [[ $mykeepass = "y" ]]; then
#  /home/abraxas/.cargo/bin/pueued -d
  pueue add -g system-setup -- sudo add-apt-repository ppa:phoerious/keepassxc -y
  pueue add -g system-setup -- sudo apt-get update
  pueue parallel 1
  pueue add -g system-setup -- sudo apt-get dist-upgrade -y
  #printf "${LILA}"
  pueue add -g system-setup -- sudo apt-get install -y keepassxc
fi
echo
printf "${LILA}"; printf "${UL1}"
echo "[11] SOFTWARE INSTALLATION"
################################################ [11] SOFTWARE INSTALLATION
printf "${NC}"; printf "${BLUE4}"
echo "INSTALL sudo apt-get install -y nano curl nfs-common xclip ssh-askpass jq taskwarrior android-tools-adb conky-all fd-find"
printf "${NC}"; printf "${BLUE3}"; echo
pueue add -g system-setup -- sudo apt-get install -y nano curl nfs-common xclip ssh-askpass taskwarrior android-tools-adb conky-all fd-find
echo
printf "${NC}"; printf "${BLUE3}"
myfonts="y"
printf "${LILA}"; printf "${UL1}"
echo "[12] WANT TO INSTALL FONTS? (y/n)"
##################################################### [12] FONTS
printf "${NC}"; printf "${BLUE3}"
echo BUTTON10
read -n 1 -t 10 myfonts
if [[ $myfonts = "y" ]]; then
  #https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  curl -X POST -H "Content-Type: application/json" -d '{"myvar1":"foo","myvar2":"bar","myvar3":"foobar"}' "https://joinjoaomgcd.appspot.com/_ah/api/messaging/v1/sendPush?apikey=304c57b5ddbd4c10b03b76fa97d44559&deviceNames=razer,Chrome,ChromeRazer&text=play%20install%20this%20font&url=https%3A%2F%2Fgithub.com%2Fromkatv%2Fpowerlevel10k-media%2Fraw%2Fmaster%2FMesloLGS%2520NF%2520Regular.ttf&file=https%3A%2F%2Fgithub.com%2Fromkatv%2Fpowerlevel10k-media%2Fraw%2Fmaster%2FMesloLGS%2520NF%2520Regular.ttf&say=please%20install%20this%20font"
  sudo apt update && sudo apt install -y zsh fonts-powerline xz-utils wget plocate
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
echo
/home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style blue --title NTFY --print "NTFY SETUP >>> DONE"

/home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style blue --title PIP --print "[14] PIP INSTALLS"; sleep $myspeed
############################################################## [14] PIP INSTALLS
pueue add -g system-setup -- pip install apprise; sleep $myspeed
pueue add -g system-setup -- pip install paho-mqtt; sleep $myspeed
########################################################### [15] DOCKER
/home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style blue --title docker --print "[15] INSTALL DOCKER"; sleep $myspeed
pueue add -g system-setup -- sudo apt-get install docker.io docker-compose -y
/home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style blue --print "$(/home/linuxbrew/.linuxbrew/bin/pueue status)"
#################################################### docker compose
/home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style blue --title clean up --print "[18] AUTOREMOVE"; sleep $myspeed
################################################################# [18] CLEAN UP
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
printf "${NC}"
sleep $myspeed
echo
pip install taskwarrior-inthe.am
sudo apt-get install cifs-utils -y
#echo; echo GOODSYNC; echo
rm -rf .antigen
printf "${NC}"
cd $HOME
#wget https://www.goodsync.com/download/goodsync-linux-x86_64-release.run
#chmod +x goodsync-linux-x86_64-release.run
#sudo ./goodsync-linux-x86_64-release.run
#sudo gsync /gs-account-enroll=abraxas678@gmail.com
#sudo gsync /activate
 if [[ $(cat /root/.bashrc) = *"switching to [abraxas]"* ]]; then sudo echo "nothing to do"; else echo "echo 'switching to [abraxas] in 5 s'; read -t 5 me; su abraxas" >> /root/.bashrc; fi

curl -sSL https://archive.heckel.io/apt/pubkey.txt | sudo apt-key add -
sudo apt install apt-transport-https
sudo sh -c "echo 'deb [arch=amd64] https://archive.heckel.io/apt debian main' > /etc/apt/sources.list.d/archive.heckel.io.list"  
sudo apt update
sudo apt install pcopy
sudo pcopy setup
sudo systemctl enable pcopy
sudo systemctl start pcopy

pueue add -g system-setup -- pip install taskwarrior-inthe.am
pueue add -g system-setup -- sudo apt-get install cifs-utils -y
rm -rf $HOME/.antigen
#echo; echo GOODSYNC; echo
printf "${NC}"
cd $HOME
#echo; echo "INSTALL GOODSYNC? (y/n)"
#mychoice="n"
#read -n 1 -t 5 mychoice
#if [[ $mychoice = "y" ]]
#then
#  wget https://www.goodsync.com/download/goodsync-linux-x86_64-release.run
#  chmod +x goodsync-linux-x86_64-release.run
#  sudo ./goodsync-linux-x86_64-release.run
#  sudo gsync /gs-account-enroll=abraxas678@gmail.com
#  sudo gsync /activate
#fi
#echo "copy files from gd:dotfiles"
#read -t 10 me
#rclone copy gd:dotfiles $HOME --max-depth 1 --filter-from="$HOME/myfilter.txt" -P
#read -t 10 me
#rclone copy gd:dotfiles/bin $HOME/bin --filter-from="$HOME/myfilter.txt" -P
#read -t 10 me
#rclone copy gd:dotfiles/docker $HOME/docker --filter-from="$HOME/myfilter.txt" -P
#read -t 10 me
#rclone copy gd:dotfiles $HOME --filter-from="$HOME/myfilter.txt" -P
#echo "RCLONE BISYNC DOTFILES (-1)"
#touch $HOME/RCLONE_TEST
#rclone copy RCLONE_TEST gd:dotfiles -P
#rclone copy gd:dotfiles/bin $HOME/bin -P
#rclone copy gd:dotfiles/bisync-filter.txt $HOME -P
#rclone bisync /home/abraxas/ gd:dotfiles --filters-file /home/abraxas/bisync-filter.txt -Pvvv --check-access --resync --skip-links
/home/linuxbrew/.linuxbrew/bin/rich --panel rounded --style blue --title "rclone copy df:.config $HOME/.config --update -Pv" --print "$(rclone copy df:.config $HOME/.config --update -Pv)"
sudo chown $user: -R 
echo DONE 
echo EXEC ZSH
exec zsh

