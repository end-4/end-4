#!/usr/bin/env bash

sudo sbctl create-keys
sudo sbctl enroll-keys -m
for kernel in /boot/vmlinuz-*; do
    echo "$kernel"
    sudo sbctl sign -s "$kernel"
done
sudo sbctl sign -s /boot/efi/EFI/Boot/BOOTx64.EFI
