#!/bin/bash

clear
echo -e
echo -e
YELLOW="\033[1;33m"
RED="\033[0;31m"
ENDCOLOR="\033[0m"
echo -e $RED" _____ _                                    "$ENDCOLOR
echo -e $RED"/  __ \ |                                   "$ENDCOLOR
echo -e $RED"| /  \/ | ___  __ _ _ __   ___ _ __         "$ENDCOLOR
echo -e $RED"| |   | |/ _ \/ _  | '_ \ / _ \ '__|        "$ENDCOLOR
echo -e $RED"| \__/\ |  __/ (_| | | | |  __/ |           "$ENDCOLOR
echo -e $RED" \____/_|\___|\__,_|_| |_|\___|_|           "$ENDCOLOR
echo -e 
echo -e $YELLOW"=     This Script Made By : Youssef el bourni :')   ="$ENDCOLOR

echo "----------------------------"
echo "| Starting Updating script |"
echo "----------------------------"

figlet -f smslant EZ

echo "\n- updatign"
echo Updating / Upgrading...
echo

sudo apt update -y
sudo apt full-upgrade -y
sudo apt --with-new-pkgs upgrade -y
sudo apt dist-upgrade -y

echo
echo Extra...
echo

sudo apt list --upgradable -a
echo
echo Type sudo apt install package
echo
echo "----------------------------"
echo "| Starting cleaning script |"
echo "----------------------------"

echo "\n- Clearing cache of removed packages"
sudo apt autoclean

echo "\n- Clearing entire cache"
sudo apt clean

echo "\n- Removing unnecessary dependencies"
sudo apt autoremove

# It will tell if nothing is found with the grep, don't worry it's ok. Relax
echo "\n- Removing obsolete configuration files"
sudo dpkg --purge $(COLUMNS=200 dpkg -l | grep "^rc" | tr -s ' ' | cut -d ' ' -f 2)

echo "\n- Removing Trash"
sudo rm -r -f ~/.local/share/Trash/*/*

echo "\n- Removing thumbnails"
sudo rm -rf ~/.thumbnails/normal/*
sudo du -sh ~/.cache/thumbnails

echo "\n- clear casche"
sleep 1
sudo rm -rf /var/cache/apt/archives/
sudo du -sh /var/cache/apt/archives/
echo
sleep 1
sudo rm -rf /var/cache/apt/archives/*deb
sudo du -sh /var/cache/apt/archives/*deb
echo
sleep 1
sudo rm -rf /var/tmp/*
sudo du -sh /var/tmp/*




echo "\n- Empty Trash"
sleep 1
sudo rm -rf "${HOME}/.local/share/Trash/"*
sudo du -sh "${HOME}/.local/share/Trash/"*
echo
sleep 1
echo "Fixing broken packages with dpkg!"
sleep 1
sudo dpkg --configure -a
echo
echo "Cleaning /var/log old logs"
sudo rm -rf /var/log/*
sleep 1
sudo find | sudo grep gz$|sudo xargs rm -rf 
sudo find | sudo grep 1$|sudo xargs rm -rf 
sudo find | sudo grep old$|sudo xargs rm -rf
sudo du -sh /var/log
sleep 2 
echo
echo "Cleaning old backups" 
sudo rm -rf /var/backups/*gz
sudo du -sh /var/backups/
echo 
sleep 2
echo
echo "Cleaning cache /home"
sudo rm -rf ~/.cache/*
sudo du -sh ~/.cache/
sleep 2

# Wine cache
echo "Wine cache /home"
rm -rf ~/.wine/drive_c/users/$USER/Temp/* 
rm -rf ~/.wine/drive_c/windows/temp/* 


echo "Disk usage"
# Show systemd journal logs
sudo journalctl --disk-usage
# Clear systemd journal logs
sudo journalctl --vacuum-time=3d

 
echo -e $YELLOW"[Mint-cleaner]:Script Finished!"$ENDCOLOR
echo -e
echo -e $RED"Thank you  ! :) Have a good day !"$ENDCOLOR
