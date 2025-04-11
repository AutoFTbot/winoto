#!/bin/bash

# Winoto - TinyKRNL Auto Installer (Interactive Menu)
# Created by AutoFTbot

echo ""
echo "======================================"
echo "   Winoto - Auto Install Windows VPS"
echo "======================================"
echo ""
echo "Pilih OS yang ingin diinstall:"
echo "  1) Tiny11"
echo "  2) Tiny10"
echo "  3) Tiny7"
echo "  4) Windows 11 (Original)"
echo "  5) Windows 10 (Original)"
echo "  6) Windows 7 (Original)"
read -p "Masukkan pilihan [1-6]: " pilihan

case "$pilihan" in
  1) OS="Tiny11"; URL="https://crustywindo.ws/files/Windows11/tiny11_23H2_x64_en-US.gz" ;;
  2) OS="Tiny10"; URL="https://crustywindo.ws/files/Windows10/tiny10_22H2_x64_en-US.gz" ;;
  3) OS="Tiny7";  URL="https://crustywindo.ws/files/Windows7/tiny7_7601_x64_en-US.gz" ;;
  4) OS="Win11";  URL="https://crustywindo.ws/files/Windows11/Windows_11_23H2_x64_en-US.gz" ;;
  5) OS="Win10";  URL="https://crustywindo.ws/files/Windows10/Windows_10_22H2_x64_en-US.gz" ;;
  6) OS="Win7";   URL="https://crustywindo.ws/files/Windows7/Windows_7_7601_x64_en-US.gz" ;;
  *) echo "Pilihan tidak valid!"; exit 1 ;;
esac

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

echo ""
echo "[*] Memulai install: $OS"
echo "[*] Download image dan tulis ke disk..."
wget -O- "$URL" --no-check-certificate | gunzip | dd of=/dev/vda bs=3M status=progress

echo "[*] Injecting RDP dan konfigurasi jaringan..."
sleep 5
mount.ntfs-3g /dev/vda2 /mnt
mkdir -p "/mnt/ProgramData/Microsoft/Windows/Start Menu/Programs/Startup"
cp -f /tmp/net.bat /mnt/ProgramData/Microsoft/Windows/Start\ Menu/Programs/Startup/
cp -f /tmp/rdp-enable.bat /mnt/ProgramData/Microsoft/Windows/Start\ Menu/Programs/Startup/

echo ""
echo "[✓] Install selesai!"
echo "🔁 VPS akan shutdown dalam 5 detik dan siap RDP!"
sleep 5
reboot
