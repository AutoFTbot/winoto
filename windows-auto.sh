#!/bin/bash

# Winoto - Auto Install TinyKRNL Windows with RDP
# Created by AutoFTbot

OS="$1"
if [ -z "$OS" ]; then
  echo "Usage: $0 [tiny11|tiny10|tiny7|win10|win11|win7]"
  exit 1
fi

case "$OS" in
  tiny11) WIN_URL="https://crustywindo.ws/files/Windows11/tiny11_23H2_x64_en-US.gz" ;;
  tiny10) WIN_URL="https://crustywindo.ws/files/Windows10/tiny10_22H2_x64_en-US.gz" ;;
  tiny7)  WIN_URL="https://crustywindo.ws/files/Windows7/tiny7_7601_x64_en-US.gz" ;;
  win11)  WIN_URL="https://crustywindo.ws/files/Windows11/Windows_11_23H2_x64_en-US.gz" ;;
  win10)  WIN_URL="https://crustywindo.ws/files/Windows10/Windows_10_22H2_x64_en-US.gz" ;;
  win7)   WIN_URL="https://crustywindo.ws/files/Windows7/Windows_7_7601_x64_en-US.gz" ;;
  *) echo "Pilihan tidak dikenali!"; exit 1 ;;
esac

echo ""
echo "======================================"
echo "   Winoto - Auto Install Windows VPS"
echo "         Installing: $OS"
echo "======================================"

INTERFACE_NAME="Ethernet Instance 0"
IP4=$(curl -4 -s icanhazip.com)
GATEWAY=$(ip route | awk '/default/ { print $3 }')

cat >/tmp/net.bat <<EOF
@echo off
netsh interface ip set address name="$INTERFACE_NAME" static $IP4 255.255.240.0 $GATEWAY
netsh interface ip set dns name="$INTERFACE_NAME" static 1.1.1.1
netsh interface ip add dns name="$INTERFACE_NAME" 8.8.8.8 index=2
exit
EOF

cat >/tmp/rdp-enable.bat <<EOF
@echo off
reg add "HKLM\\SYSTEM\\CurrentControlSet\\Control\\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
netsh advfirewall firewall set rule group="remote desktop" new enable=Yes
exit
EOF

echo "[*] Downloading and writing Windows image..."
wget -O- "$WIN_URL" --no-check-certificate | gunzip | dd of=/dev/vda bs=3M status=progress

echo "[*] Injecting startup RDP and network config..."
sleep 5
mount.ntfs-3g /dev/vda2 /mnt
mkdir -p "/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs/Startup"
cp -f /tmp/net.bat /mnt/ProgramData/Microsoft/Windows/Start\ Menu/Programs/Startup/
cp -f /tmp/rdp-enable.bat /mnt/ProgramData/Microsoft/Windows/Start\ Menu/Programs/Startup/

echo "[✓] Install selesai. VPS akan shutdown dalam 5 detik dan siap digunakan via RDP!"
sleep 5
poweroff
