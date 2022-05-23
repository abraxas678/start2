#!/bin/bash
clear
#delstart="n"
#echo; echo "DELETE FOLDER START? (y/n)"; echo
#read -n 1 -t 5 delstart
#if [[ $delstart = "y" ]]
#then
#  cd $HOME
#  rm -rf 
#fi
echo
echo "[1] SYSTEM UPATE AND UPGRADE"; sleep 2
##########################################  [1]
echo "sudo apt-get update && sudo apt-get upgrade -y"
echo; sleep 4
sudo apt-get update && sudo apt-get upgrade -y
echo
echo "[2] INSTALL ZSH -- Oh-my-Zsh -- Antigen FRAMEWORK"; sleep 2
########################################################  [2]
echo; cd $HOME
sudo apt install -y zsh php
echo; echo INSTALL OH MY ZSH
sleep 2; echo
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
curl -L git.io/antigen > antigen.zsh
echo
echo "[3] CLONE REPOSITORY"; sleep 2
###############################################################################  [3]
cd $HOME
sleep 2
git clone https://github.com/abraxas678/start2.git



echo "[5] setup GPG encryption"; sleep 2
##########################################  [5]
echo
echo "gpg -a --export-secret-keys [key-id] >key.asc"
echo "gpg --import"
echo
if [[ $(which gpg) = *"/usr/bin/gpg"* ]]
then
  echo; echo gpg INSTALLED
  sleep 2
else
  echo; echo INSTALL gpg
  sleep 2
  apt install gpg -y
  echo
  #echo SETUP GPG MANUALLY VIA OD VAULT
  #echo gpg --import
  echo
  echo "gpg -a --export-secret-keys [key-id] >key.asc"
  echo "gpg --import"
  echo
  echo rko files to gd:sec please
  echo
  echo START IMPORT
  read me
  rclone copy gd:sec ./tempinstall --include="rko-p*" -Pc --max-depth 1
  gpg --import ./tempinstall/rko-p*
  rm -f ./tempinstall/rko-p*
  echo; echo REMOVE rko files from gd:sec now; echo
  echo; echo BUTTON
  read me
fi
echo
echo "CHECKING ENVIRONMENT CONDITION:"; echo; sleep 2

if [[ $(which rclone) = *"/usr/bin/rclone"* ]]
then
  echo "RCLONE_INSTALL=1"
  RCLONE_INSTALL=1
  if [[ ! -f ~/.config/rclone/rclone.conf ]]; then
    echo "RCLONE_CONFIG=0"
    RCLONE_CONFIG=0
  else
    echo "RCLONE_CONFIG=1"
    RCLONE_CONFIG=1
    rclonesize=$(rclone size ~/.config/rclone/rclone.conf --json | jq .bytes)
    echo "rlone.conf SIZE: $rclonesize"
    echo
    if [[ $rclonesize -lt 3000 ]]
    then
      if [[ $(rclone listremotes | grep gd:) = "gd:" ]]
      then
        echo "RCLONE_GD=1"
        RCLONE_GD=1
      else
        echo "RCLONE_GD=0"
        RCLONE_GD=0
        echo; echo "SETUP GOOGLE DRIVE NOW"; echo; sleep 2
        rclone config
      fi
    else
      echo "RCLONE_COMPLETE=1"
      RCLONE_COMPLETE=1
    fi
  fi
  

else
  echo "RCLONE_INSTALL=0"; sleep 1
  echo "RCLONE_CONFIG=0"; sleep 1
  echo "RCLONE_GD=0"; sleep 1
  eccho "RCLONE_COMPLETE=0"; sleep 1
  RCLONE_INSTALL=0
  RCLONE_CONFIG=0
  RCLONE_GD=0
  RCLONE_COMPLETE=0
fi

if [[ $RCLONE_INSTALL = "0" ]]
then
echo
echo "[4] SETUP RCLONE"; echo; sleep 2; echo
############################################ [4]
echo
cd $HOME/start2
echo
echo PWD: $PWD
echo; sleep 2
if [[ $(which rclone) = *"/usr/bin/rclone"* ]]
then
  echo; echo RCLONE ALREADY INSTALLED
  sleep 2; echo
  if [[ ! -f ~/.config/rclone/rclone.conf ]]; then
  echo; echo "SETUP GD ON RCLONE"
  rclone config
  fi
  rclonesize=$(rclone size ~/.config/rclone/rclone.conf --json | jq .bytes)
  echo "rlone.conf SIZE: $rclonesize"
  echo
  if [[ $rclonesize -lt 3000 ]]
  then
    echo; echo GPG DECRYPT RCLONESETUP; echo
    echo "gpg --decrypt rclone_secure_setup2gd.sh.asc > rclonesetup.sh"
    echo
    sleep 2
    gpg --decrypt rclone_secure_setup2gd.sh.asc > rclonesetup. sh
    sudo chmod +x *.sh
    echo; echo RCLONESETUP; echo
    echo BUTTON
    read me
    ./rclonesetup.sh
    rm rclonesetup.sh
  fi  
else
  echo; echo RCLONE NEEDS TO GET INSTALLED
  sleep 2
    echo; echo GPG DECRYPT RCLONESETUP; echo
    echo "gpg --decrypt rclone_secure_setup2gd.sh.asc > rclonesetup.sh"
    echo
    sleep 2
    gpg --decrypt rclone_secure_setup2gd.sh.asc > rclonesetup. sh
    sudo chmod +x *.sh
    echo; echo RCLONESETUP; echo
    echo BUTTON
    read me
    ./rclonesetup.sh
    rm rclonesetup.sh
fi



echo
echo; echo "[6] SOFTWARE INSTALL -- sudo apt-get install restic python3-pip -y"
###############################################################################  [6]
echo; echo "[7] SOFTWARE INSTALL RESTIC PYTHON"; sleep 2
###############################################################################  [7]
sudo apt-get install restic python3-pip -y
echo
echo
echo "[8] SETUP SSH"
###############################################################################  [8]
sshresult=$(ssh -T git@github.com)
if [[ $sshresult = *"successfully authenticated"* ]]
then
  echo "SSH SETUP DONE - GITHUB ACCESS SUCCESSFULL"; sleep 2
else
echo STARTING SHH SETUP; sleep 2
echo "rclone copy gd:/sec/start/id_rsa.asc . -P"
echo
rclone copy gd:/sec/start/id_rsa.asc . -P
echo
sleep 2
echo "gpg --decrypt id_rsa.asc > id_rsa"
echo
gpg --decrypt id_rsa.asc > id_rsa
rm id*.asc
sudo mkdir $HOME/.ssh
echo; echo "SHH FOLDER RIGHTS"; echo
sudo chown abraxas678:100 $HOME -R
sudo chmod 700 -R $HOME
mv id_rsa $HOME/.ssh
fi
echo
echo STARTING SSH AGENT; echo; sleep 2
eval `ssh-agent -s`
echo; echo SETTING PERMISSIONS; echo; sleep 2
sudo chmod 400 ~/.ssh/* -R
ssh-add ~/.ssh/id_rsa
sudo chmod 700 ~/.ssh
sudo chmod 644 ~/.ssh/authorized_keys
sudo chmod 644 ~/.ssh/known_hosts
sudo chmod 644 ~/.ssh/config
sudo chmod 600 ~/.ssh/id_rsa
sudo chmod 644 ~/.ssh/id_rsa.pub
echo
##########################################rclone copy gdsec:dotfiles ./dotfiles -Pv --skip-links --fast-list
#git clone git@github.com:abraxas678/dotfiles.git
#echo
echo "[9] RESTORE LATEST RESTIC SNAPSHOT"; sleep 2; echo 
################################################### [9]
restic -r rclone:gd:restic snapshots
echo
echo "Which snapshot do you wish to restore?"
echo
printf ">>> "; read mysnapshot
myrestore="n"
echo
echo "restic -r rclone:gd:restic restore $mysnapshot --target $PWD"; echo
echo; echo "restore to $PWD, correct? (y/n)"; 
read -n 1 myrestore
if [[ $myrestore = "y" ]]
then
  rm -rf $HOME/tmprestigrestore
  echo; echo "RESTIC TO TMP FOLDER"; echo; sleep 2
  restic -r rclone:gd:restic restore $mysnapshot --target $HOME/tmprestigrestore
  echo; echo "RCLONE TO $HOME"; echo; sleep 2
  rclone copy $HOME/tmprestigrestore/ $HOME/ -Pv
  echo
fi
#################################################################  ab hier das script weiter machen
########################################## KEEPASSXC
echo; echo; echo "INSTALL KEEPASSXC"
echo
mykeepass="n"
echo "WANT TO INSTALL KEEPASSXC? (y/n)"
read -n 1 -t 40 mykeepass
#printf "${BLUE3}"
if [[ $mykeepass = "y" ]]; then
sudo add-apt-repository ppa:phoerious/keepassxc -y
sudo apt-get update
sudo apt-get dist-upgrade -y
#printf "${BLUE1}"
sudo apt-get install -y keepassxc
fi
echo
echo "INSTALL sudo apt-get install -y nano curl nfs-common xclip ssh-askpass jq taskwarrior android-tools-adb conky-all"
echo
sudo apt-get install -y nano curl nfs-common xclip ssh-askpass jq taskwarrior android-tools-adb conky-all fd-find
echo
echo FONTS
echo
myfonts="n"
echo "WANT TO INSTALL FONTS? (y/n)"
read -n 1 -t 20 myfonts
if [[ $myfonts = "y" ]]; then
  #https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  curl -X POST -H "Content-Type: application/json" -d '{"myvar1":"foo","myvar2":"bar","myvar3":"foobar"}' "https://joinjoaomgcd.appspot.com/_ah/api/messaging/v1/sendPush?apikey=304c57b5ddbd4c10b03b76fa97d44559&deviceNames=razer,Chrome,ChromeRazer&text=play%20install%20this%20font&url=https%3A%2F%2Fgithub.com%2Fromkatv%2Fpowerlevel10k-media%2Fraw%2Fmaster%2FMesloLGS%2520NF%2520Regular.ttf&file=https%3A%2F%2Fgithub.com%2Fromkatv%2Fpowerlevel10k-media%2Fraw%2Fmaster%2FMesloLGS%2520NF%2520Regular.ttf&say=please%20install%20this%20font"
  sudo apt update && sudo apt install -y zsh fonts-powerline xz-utils wget  
  ###mlocate  -----> in tmu aufsetzen
  ###### https://github.com/suin/git-remind
  # sleep 1
fi
############################ NTFY
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
############################ PIP INSTALLS
pip install apprise
pip install paho-mqtt
############################
############################ DOCKER
apt-get install docker.io docker-compose -y
############################
echo
brewsetup="n"
echo "START BREW SETUP?  (y/n)              --------------timeouut 20 n"
echo
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
sleep 2
echo
exec zsh
echo DONE
