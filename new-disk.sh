#!/bin/bash
x=0; tput sc; while [[ $x -eq 0 ]]; do
  read -p "Setup Disks? (y/n)" MY_DISKS
  [[ $MY_DISKS != "y" ]] && x=1 && exit
  [[ $MY_DISKS != "n" ]] && x=1
  sleep 1
done
echo "format new disk? (y/n)"
read -n 1 my_answer
echo ok
[[ $my_answer = "y" ]] && sudo lsblk && printf "device-name: "; read DEVICE_NAME && sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/$DEVICE_NAME
 
 ts=$(date +"%s")

sudo mkdir /mnt/disk1 >/dev/null 2>/dev/null
sudo mkdir /mnt/disk1/home >/dev/null 2>/dev/null
sudo mkdir /mnt/disk1/var >/dev/null 2>/dev/null

read -p "var or home? " MY_FOLDER

 sudo mount -o discard,defaults /dev/$DEVICE_NAME /mnt/disk1/$MY_FOLDER

 sudo chmod a+w /mnt/disk1/$MY_FOLDER

 sudo cp /etc/fstab /etc/fstab-$ts.backup

 sudo blkid /dev/$DEVICE_NAME

 printf "UUID: "; read UUID

 ## --> UUID

 sudo echo "UUID=$UUID /$MY_FOLDER ext4 discard,defaults,nofail 0 2" >> /etc/fstab
 echo "UUID=$UUID /$MY_FOLDER ext4 discard,defaults,nofail 0 2        in /etc/fstab"
 echo BUTTON; read me
 sudo nano /etc/fstab

 cat /etc/fstab

 echo "move /$MY_FOLDER to disk? (y/n)"
[[ $my_answer = "y" ]] && sudo cp -apx /$MY_FOLDER/* /mnt/disk1/$MY_FOLDER && sudo mv /$MY_FOLDER /$MY_FOLDER.old && sudo mkdir /$MY_FOLDER


# https://www.suse.com/support/kb/doc/?id=000018399
#Edit the /etc/fstab file:
#Replace /mnt/newvar with /var
#Save and Close the file.
#Note: The new partition is now configured to be mounted at /var on boot.