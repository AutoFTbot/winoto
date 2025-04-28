# 🪟 Winoto - Auto Install Windows + RDP on VPS

**Winoto** adalah skrip shell otomatis untuk menginstal Windows (10/Server) di VPS (DigitalOcean, Vultr, dll) **tanpa perlu masuk ke Recovery Mode**, plus otomatis aktifkan RDP dan atur IP static.

> 🧪 Versi ini masih Beta! Jangan pakai di server produksi sebelum testing dulu.

---

## 🚀 Cara Pakai

1. Gunakan VPS dengan storage kosong (minimal 25 GB).
2. Login ke VPS via SSH.
3. Jalankan:

```bash
wget https://raw.githubusercontent.com/AutoFTbot/winoto/refs/heads/main/rdp-kvm.sh && rdp-kvm.
```
```bash
wget https://raw.githubusercontent.com/AutoFTbot/winoto/refs/heads/main/rdp-non-kvm.sh && rdp-non-kvm.sh
```
