#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo 'Absolutely personal install script for a fresh EndeavourOS system.'
echo 'Public for accessibility, not public use. NO contribution will be accepted.'
echo 'THIS CAN NUKE YOUR SHIT, YOU HAVE BEEN WARNED.'
read -rp "[[ Enter to continue ]] " _dummyVar

############# SYSTEM ###############

./install-packages.sh

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

cd "$SCRIPT_DIR"
./install-real-dotfiles.sh

# Clear cache
echo '[[ Clearing cache ]]'
yay -Sc

echo '[[ Setting up secure boot ]]'
sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=endeavouros --modules="tpm" --disable-shim-lock
echo '[Action required] Go to firmware settings and reset/clear secure boot keys, then boot into the system and run install-finalize-eos.sh'
read -rp "[[ Press Enter to reboot, or Ctrl+C to cancel ]] " _dummyVar
systemctl reboot --firmware-setup
