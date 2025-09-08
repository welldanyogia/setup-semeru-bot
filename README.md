# Setup Semeru Bot

Skrip `install_multi.sh` membantu memasang beberapa instance bot Telegram Semeru secara otomatis.

## Prasyarat
- Sistem operasi berbasis Linux dengan `systemd`.
- Akses `sudo` untuk memasang paket dan membuat service.
- Git serta koneksi internet.

## Cara Penggunaan
1. **Jalankan skrip**
   ```bash
   ./install_multi.sh
   ```
2. **Masukkan URL repositori bot** saat diminta. Skrip akan meng-klon repositori jika belum ada.
3. **Tentukan jumlah bot** yang ingin diinstal.
4. **Masukkan token Telegram** untuk setiap bot.
5. Skrip akan membuat lingkungan virtual, memasang dependensi, serta membuat dan mengaktifkan service `systemd` untuk tiap bot.

## Mengelola Service
- Mulai ulang bot: `sudo systemctl restart semeru-bot1`
- Melihat log: `sudo journalctl -u semeru-bot1 -f`

Service tambahan diberi nama `semeru-bot2`, `semeru-bot3`, dan seterusnya.

## Menghapus
Untuk menonaktifkan dan menghapus service, jalankan:
```bash
sudo systemctl disable --now semeru-bot1
sudo rm /etc/systemd/system/semeru-bot1.service
```
Ulangi untuk setiap bot yang ingin dihapus, lalu jalankan `sudo systemctl daemon-reload`.

## Catatan
Jalankan skrip ini dari direktori yang berisi `install_multi.sh`. Pastikan hak eksekusinya aktif dengan `chmod +x install_multi.sh` bila diperlukan.
