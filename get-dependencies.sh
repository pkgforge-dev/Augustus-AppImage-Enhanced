#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm libdecor

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
if [ "${DEVEL_RELEASE-}" = "1" ]; then
    package="augustus-git"
    make-aur-package "$package"
else
    package="augustus"
    sudo pacman -S --noconfirm "$package"
fi

pacman -Q "$package" | awk '{print $2; exit}' > ~/version

# If the application needs to be manually built that has to be done down here
