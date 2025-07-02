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
pacman -Q power-profiles-daemon && sudo pacman -Rnsdd power-profiles-daemon --noconfirm

echo '[[ Chaotic AUR ]]'
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm
if ! grep -q '^\[chaotic-aur\]' /etc/pacman.conf; then
    echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n" | sudo tee -a /etc/pacman.conf
fi

echo '[[ Installing stuff ]]'
yay -Syyu --needed --noconfirm \
    sbctl \
    linux-clear-bin linux-clear-headers-bin \
    nvidia-inst \
    google-chrome \
    kate visual-studio-code-bin \
    github-cli github-desktop-bin \
    ollama-cuda \
    mpv ani-cli \
    powertop tlp \
    sddm sddm-kcm breeze \
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

echo '[[ Ollama ]]'
sudo systemctl enable ollama

echo '[[ TLP ]]'
sudo systemctl enable tlp

echo '[[ Nvidia ]]'
nvidia-inst -p
cp ./etc/dracut.conf.d/force-i915.conf /etc/dracut.conf.d/force-i915.conf
sudo dracut-rebuild

echo '[[ Time sync with Windows ]]'
sudo timedatectl set-local-rtc 1

############# USER ###############

# Install dotfiles
read -rp "Dotfiles? [y/n]: " install_dotfiles
if [[ "$install_dotfiles" != "y" && "$install_dotfiles" != "Y" ]]; then
    echo "Skipping dotfiles installation."
else
    cd ~/Downloads
    git clone https://github.com/end-4/dots-hyprland.git
    cd dots-hyprland
    ./install.sh
fi

# Clear cache
echo '[[ Clearing cache ]]'
yay -Sc

echo '[[ Setting up secure boot ]]'
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=endeavouros --modules="tpm" --disable-shim-lock
echo '[Action required] Go to firmware settings and reset/clear secure boot keys, then boot into the system and run install-finalize.sh'
read -rp "[[ Press Enter to reboot, or Ctrl+C to cancel ]] " dummyVar
systemctl reboot --firmware-setup
