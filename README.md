# 🚀 Winoto (Beta) — Auto Install Windows on VPS

Script ini memungkinkan kamu untuk menginstall Windows secara otomatis di VPS (seperti DigitalOcean, Vultr, dll) **tanpa perlu masuk recovery mode**!

## 🔥 Fitur
- Pilih OS Windows: 10 / 2012 / 2016 / 2019 / 2022
- Auto setting IP Static dari public IP VPS
- Tidak perlu masuk recovery manual
- Tinggal tunggu → login via VNC Console

## 🧪 Status
> Versi: Beta v0.1  
> Untuk testing dan review lebih lanjut sebelum final release.

## 🛠 Cara Pakai

### 1. Deploy VPS Ubuntu (20.04 / 22.04)
Minimal RAM 2GB & Storage 25GB.

### 2. Jalankan Perintah Berikut:

```bash
wget https://raw.githubusercontent.com/AutoFTbot/Winoto/main/windows-auto.sh
chmod +x windows-auto.sh
./windows-auto.sh
