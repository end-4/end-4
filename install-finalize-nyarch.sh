#!/usr/bin/env bash

sudo sbctl create-keys
sudo sbctl enroll-keys -m
for kernel in /boot/vmlinuz-*; do
    echo "$kernel"
    sudo sbctl sign -s "$kernel"
done
sudo sbctl sign -s /efi/EFI/Boot/BOOTx64.EFI
sudo sbctl verify | sed -E 's|^.* (/.+) is not signed$|sudo sbctl sign -s "\1"|e'
sudo sbctl status

echo '[Action required] Go to firmware settings and enable secure boot and you'\''re done!'
read -rp "[[ Press Enter to reboot, or Ctrl+C to cancel ]] " dummyVar
systemctl reboot --firmware-setup
