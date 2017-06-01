#!/bin/bash

if [[ $1 == "" ]]
then
    echo "Usage: $0 official_version"
    echo ""
    echo "Example:"
    echo "    $0 1.1.7"
    exit 1
fi

DEBIAN=1.1.0-1
OFFICIAL="${1}-1"
V_DEBIAN=$(echo "$DEBIAN"|cut -d '-' -f 1)
V_OFFICIAL="$1"

set -e

if [[ ! -f "telegram-desktop_${DEBIAN}.debian.tar.xz" || ! -f "telegram-desktop_${V_DEBIAN}.orig.tar.gz" ]]
then
    apt-get source telegram-desktop=${DEBIAN}
    rm -fr "telegram-desktop-${V_DEBIAN}"
fi

if [[ ! -f "telegram-desktop_${V_OFFICIAL}.orig.tar.gz" ]]
then
    wget -O "telegram-desktop_${V_OFFICIAL}.orig.tar.gz" "https://github.com/telegramdesktop/tdesktop/archive/v${V_OFFICIAL}.tar.gz"
fi

if [[ -d debian ]]
then
    rm -fr debian
fi

tar Jxvf "telegram-desktop_${DEBIAN}.debian.tar.xz"
cp debian/changelog debian/changelog.bak
echo "telegram-desktop (${OFFICIAL}) unstable; urgency=medium

  * New upstream release

 -- Ronmi Ren <ronmi.ren@gmail.com>  $(LANG= date -R)
" > debian/changelog
cat debian/changelog.bak >> debian/changelog
rm debian/changelog.bak
tar Jcvf "telegram-desktop_${OFFICIAL}.debian.tar.xz" debian

if [[ -d "telegram-desktop" ]]
then
    rm -fr telegram-desktop
fi

if [[ -d "telegram-desktop-${V_OFFICIAL}" ]]
then
    rm -fr "telegram-desktop-${V_OFFICIAL}"
fi

mkdir "telegram-desktop-${V_OFFICIAL}"
(
    cd "telegram-desktop-${V_OFFICIAL}"
    tar zxvf "../telegram-desktop_${V_OFFICIAL}.orig.tar.gz" --strip-component 1
    tar Jxvf "../telegram-desktop_${OFFICIAL}.debian.tar.xz"
)
dpkg-source -b "telegram-desktop-${V_OFFICIAL}"

docker run --rm -v "$(pwd):/data" -v "$(pwd)/hook.sh:/prebuild" ronmi/dbuilder:stretch "telegram-desktop_${OFFICIAL}.dsc"
