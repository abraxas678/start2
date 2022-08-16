#!/bin/bash
echo "format new disk? (y/n)"
read -n 1 my_answer
echo ok 
[[ $my_answer = "y" ]] && sudo lsblk && printf "device-name: "; read DEVICE_NAME && sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/$DEVICE_NAME
 
 ts=$(date +"%s")

 sudo mkdir /mnt/disk1
 sudo mkdir /mnt/disk1/home

 sudo mount -o discard,defaults /dev/sdb /mnt/disk1/home

 sudo chmod a+w /mnt/disk1/home

 sudo cp /etc/fstab /etc/fstab-$ts.backup

 sudo blkid /dev/sdb

 printf "UUID: "; read UUID

 ## --> UUID

 sudo echo "UUID=$UUID /home ext4 discard,defaults,nofail 0 2" >> /etc/fstab
 echo "UUID=$UUID /home ext4 discard,defaults,nofail 0 2        in /etc/fstab"
 echo BUTTON; read me
 sudo nano /etc/fstab

 cat /etc/fstab

 echo "move /home to disk? (y/n)"
[[ $my_answer = "y" ]] && sudo cp -apx /home/* /mnt/disk1/home && sudo mv /home /home.old && sudo mkdir /home


# https://www.suse.com/support/kb/doc/?id=000018399
#Edit the /etc/fstab file:
#Replace /mnt/newvar with /var
#Save and Close the file.
#Note: The new partition is now configured to be mounted at /var on boot.
#Restart the server