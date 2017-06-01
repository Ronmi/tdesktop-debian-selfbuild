#!/bin/bash

echo 'deb http://ftp.tw.debian.org/debian stretch main' > /etc/apt/sources.list
echo 'deb http://security.debian.org/ stretch/updates main' >> /etc/apt/sources.list
echo 'deb http://ftp.tw.debian.org/debian unstable main' >> /etc/apt/sources.list
echo 'deb http://ftp.tw.debian.org/debian experimental main' >> /etc/apt/sources.list
echo 'deb-src http://ftp.tw.debian.org/debian stretch main' >> /etc/apt/sources.list
echo 'deb-src http://security.debian.org/ stretch/updates main' >> /etc/apt/sources.list
echo 'deb-src http://ftp.tw.debian.org/debian unstable main' >> /etc/apt/sources.list
echo 'deb-src http://ftp.tw.debian.org/debian experimental main' >> /etc/apt/sources.list

echo 'Package: *
Pin: release a=unstable
Pin-Priority: 100

Package: *
Pin: release a=experimental
Pin-Priority: 100
' > /etc/apt/preferences.d/10unstable
