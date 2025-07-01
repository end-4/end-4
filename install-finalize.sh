#!/usr/bin/env bash

sudo sbctl create-keys
sudo sbctl enroll-keys -m
for kernel in /boot/vmlinuz-*; do
    sudo sbctl sign -s "$kernel"
done
sbctl sign -s /boot/efi/EFI/Boot/BOOTx64.EFI