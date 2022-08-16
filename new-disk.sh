#!/bin/bash
echo "format new disk? (y/n)"
read -n 1 my_answer
[[ $my_answer = "y" ]] && sudo lsblk && printf "device-name: "; read DEVICE_NAME && sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/$DEVICE_NAME
 
 sudo mount -o discard,defaults /dev/sdb /home

 sudo chmod a+w /home

 sudo cp /etc/fstab /etc/fstab.backup

 sudo blkid /dev/sdb

 printf "UUID:"; read UUID

 ## --> UUID

 sudo echo "UUID=$UUID /home ext4 discard,defaults,nofail 0 2" >> /etc/fstab

 cat /etc/fstab
