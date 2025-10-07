#!/usr/bin/env bash

# Copy mpv config
echo '[[ mpv ]]'
mkdir -p ~/.config/mpv
cp ./.config/mpv/* ~/.config/mpv/

# Copy fcitx5 config
echo '[[ fcitx5 ]]'
mkdir -p ~/.config/fcitx5
cp -r ./.config/fcitx5/* ~/.config/fcitx5/
cp ./.config/hypr/custom/env.conf ~/.config/hypr/custom/env.conf
