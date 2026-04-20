#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm cmake nasm sdl3_mixer

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

if [ "${DEVEL_RELEASE-}" = "1" ]; then
    echo "Building Augustus..."
    echo "---------------------------------------------------------------"
    REPO="https://github.com/Keriew/augustus"
    VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
    git clone --recursive --depth 1 "$REPO" ./augustus
    echo "$VERSION" > ~/version

    cmake -B build -S ./augustus \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DSDL_VERSION=3
    cmake --build build -j$(nproc)
    cmake --install build
else
    sudo pacman -S --noconfirm augustus
    pacman -Q augustus | awk '{print $2; exit}' > ~/version
fi
