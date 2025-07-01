#!/usr/bin/env bash

echo 'Absolutely personal install script for a fresh EndeavourOS system.'
echo 'Public for accessibility, not public use. NO contribution will be accepted.'
echo 'THIS CAN NUKE YOUR STUFF, YOU HAVE BEEN WARNED.'
printf '[[ Enter to continue ]] '

read dummyVar

############# SYSTEM ###############

echo '[[ Nuking stuff ]]'
pacman -Q vi && sudo pacman -Rns vi --noconfirm
pacman -Q firefox && sudo pacman -Rns firefox --noconfirm

echo '[[ Installing stuff ]]'
yay -S --needed --noconfirm \
    google-chrome \
    kate visual-studio-code-bin \
    github-cli github-desktop-bin \
    ollama-cuda \
    sddm sddm-kcm \
    zram-generator

echo '[[ zram setup ]]'
sudo cp ./etc/systemd/zram-generator.conf /etc/systemd/zram-generator.conf
sudo systemctl daemon-reload
sudo systemctl start /dev/zram0

echo '[[ Grub ]]'
sudo cp ./etc/default/grub /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo '[[ SDDM ]]'
sudo mkdir -p /etc/sddm.conf.d
sudo cp ./etc/sddm.conf /etc/sddm.conf
sudo systemctl enable sddm

############# USER ###############

# Install dotfiles
cd ~/Downloads
git clone https://github.com/end-4/dots-hyprland.git
cd dots-hyprland
./install.sh

# Clear cache
yay -Sc


