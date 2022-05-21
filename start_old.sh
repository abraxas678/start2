#!/bin/bash
ts=$(date +"%s")
cd $HOME
git clone git@github.com:abraxas678/start.git
cd start
gpg --decrypt rclone_secure_setup2gd.sh.asc > rclonesetup.sh
sudo chmod +x *.sh
./rclonesetup.sh
rm rclonesetup.sh
echo
echo SHH
echo
<<<<<<< HEAD
rclone copy gd:/sec/start/id_rsa.asc . -P
gpg --decrypt id_rsa.asc > id_rsa
rm *.asc
sudo mkdir $HOME/.ssh
sudo chown abraxas678:100 $HOME -R
sudo chmod 700 -R $HOME
mv id_rsa $HOME/.ssh
=======
>>>>>>> 808fd0759af0af39c8506c534c67abecb83c48fd
eval `ssh-agent -s`
sudo chmod 400 ~/.ssh/* -R
ssh-add ~/.ssh/id_rsa
sudo chmod 700 ~/.ssh
sudo chmod 644 ~/.ssh/authorized_keys
sudo chmod 644 ~/.ssh/known_hosts
sudo chmod 644 ~/.ssh/config
sudo chmod 600 ~/.ssh/id_rsa
sudo chmod 644 ~/.ssh/id_rsa.pub
echo
git clone git@github.com:abraxas678/dotfiles.git




