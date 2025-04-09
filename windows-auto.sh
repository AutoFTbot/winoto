#!/bin/bash

echo ""
echo "======================================"
echo "   Winoto - Auto Install Windows VPS"
echo "   Created by AutoFTbot - Beta v0.1"
echo "======================================"
echo ""
echo "Silakan pilih OS yang ingin diinstall:"
echo "  1.) Windows 10"
echo "  2.) Windows Server 2012 R2"
echo "  3.) Windows Server 2016"
echo "  4.) Windows Server 2019"
echo "  5.) Windows Server 2022"
echo ""

read -p "Pilih [1-5]: " selectos

# Ethernet default name
ethernt="Ethernet Instance 0"

# Pilih image
case "$selectos" in
  1|"") selectos="https://image.yha.my.id/2:/windows10.gz";;
  2) selectos="https://image.yha.my.id/2:/windows2012.gz";;
  3) selectos="https://image.yha.my.id/2:/windows2016.gz";;
  4) selectos="https://image.yha.my.id/2:/windows2019.gz";;
  5) selectos="https://image.yha.my.id/2:/windows2022.gz";;
  *) echo "Pilihan salah!"; exit 1;;
esac

IP4=$(curl -4 -s icanhazip.com)
GATEWAY=$(ip route | awk '/default/ {print $3}')

# Buat file konfigurasi network Windows
cat >/tmp/net.bat<<EOF
@ECHO OFF
cd.>%windir%\\GetAdmin
if exist %windir%\\GetAdmin (del /f /q "%windir%\\GetAdmin") else (
echo CreateObject^("Shell.Application"^).ShellExecute "%~s0", "%*", "", "runas", 1 >> "%temp%\\Admin.vbs"
"%temp%\\Admin.vbs"
del /f /q "%temp%\\Admin.vbs"
exit /b 2)

netsh -c interface ip set address name="$ethernt" source=static address=$IP4 mask=255.255.255.0 gateway=$GATEWAY
netsh -c interface ip add dnsservers name="$ethernt" address=1.1.1.1 index=1 validate=no
netsh -c interface ip add dnsservers name="$ethernt" address=8.8.8.8 index=2 validate=no

ECHO SELECT VOLUME=%%SystemDrive%% > "%SystemDrive%\\diskpart.extend"
ECHO EXTEND >> "%SystemDrive%\\diskpart.extend"
START /WAIT DISKPART /S "%SystemDrive%\\diskpart.extend"

cd /d "%ProgramData%\\Microsoft\\Windows\\Start Menu\\Programs\\Startup"

del "%~f0"
exit
EOF

# Tulis image ke /dev/vda
echo "Mengunduh dan menulis image Windows ke disk..."
wget --no-check-certificate -O- $selectos | gunzip | dd of=/dev/vda bs=3M status=progress

# Mount dan salin file network
echo "Menyalin konfigurasi network ke Windows..."
mount.ntfs-3g /dev/vda2 /mnt
cp -f /tmp/net.bat "/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs/Startup/net.bat"

echo "Instalasi selesai. Server akan dimatikan dalam 5 detik..."
sleep 5
poweroff
