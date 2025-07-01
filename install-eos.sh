#!/usr/bin/env bash

echo 'Absolutely personal install script for a fresh EndeavourOS system.'
echo 'Public for accessibility, not public use. NO contribution will be accepted.'
echo ''

yay -S --needed --noconfirm google-chrome visual-studio-code-bin github-cli github-desktop-bin

cd ~/Downloads
git clone https://github.com/end-4/dots-hyprland.git
cd dots-hyprland
./install.sh

