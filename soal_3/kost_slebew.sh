#!/bin/bash
DB="data/penghuni.csv"
LOG="log/tagihan.log"
HISTORY="sampah/history_hapus.csv"
LAPORAN="rekap/laporan_bulanan.txt"

check_tagihan() {
while IFS=',' read -r nama kamar harga tanggal status
do
  if [[ "$status" == "menunggak" ]]; then
     echo "[$(date '+%F %T')] TAGIHAN: $nama (Kamar $kamar) Menunggak Rp$harga" >> "$LOG"
  fi
done < "$DB"
}
if [[ "$1" == "--check" ]]; then
  check_tagihan
  exit
fi


tambah_penghuni() {
echo "=============================="
echo "       TAMBAH PENGHUNI        "
echo "=============================="

read -p "Nama				: " nama
read -p "Nomor Kamar			: " kamar
read -p "Harga Sewa			: " harga
read -p "Tanggal Masuk (YYYY-MM-DD)	: " tanggal
read -p "Status Awal (Aktif/Menunggak)	: " status

if ! [[ $harga =~ ^[0-9]+$ ]]; then
  echo "[X] Harga harus angka!"
  read -p "Klik Enter..."
  return
fi

if ! date -d "$tanggal" >/dev/null 2>&1; then
  echo "[X] Format tanggal salah!"
  read -p "Klik Enter..."
  return
fi

if [[ "$tanggal" > "$(date +%F)" ]]; then
  echo "[X] Tidak boleh tanggal masa depan!"
  read -p "Klik Enter..."
  return
fi

if grep -q ",$kamar," "$DB"; then
  echo "[X] Kamar sudah terisi!"
  read -p "Klik Enter..."
  return
fi

status=$(echo "$status" | tr '[:upper:]' '[:lower:]')
if [[ "$status" != "aktif" && "$status" != "menunggak" ]]; then
  echo "[X] Status harus Aktif/Menunggak"
  read -p "Klik Enter..."
  return
fi

echo "$nama,$kamar,$harga,$tanggal,$status" >> "$DB"

echo "Berhasil ditambahkan!"
read -p "Klik Enter..."
}

hapus_penghuni() {
echo "========== HAPUS =========="
read -p "Nama penghuni yang akan dihapus: " nama
tanggal=$(date +%F)
awk -F',' -v nama="$nama" -v tgl="$tanggal" '
BEGIN{OFS=","}
tolower($1)==tolower(nama){
print $0,tgl >> "'$HISTORY'"
}
' "$DB"

sed -i "/^$nama,[^,]*,/Id" "$DB"

echo "Data dipindah ke history & dihapus"
read -p "Klik Enter..."
}

tampilkan() {
echo "===================================================================="
echo "                          DAFTAR PENGHUNI                           "
echo "===================================================================="

awk -F',' '
BEGIN {
total=0; aktif=0; tunggak=0;
printf "%-3s | %-15s | %-6s | %-10s | %-12s\n", "No","Nama","Kamar","Harga","Status"
print "--------------------------------------------------------------------"
}
{
printf "%-3d | %-15s | %-6s | Rp%-9s | %-12s\n", NR,$1,$2,$3,$5
total++
if (tolower($5)=="aktif") aktif++
else if (tolower($5)=="menunggak") tunggak++
}
END {
print "--------------------------------------------------------------------"
printf "Total Penghuni : %d | Aktif : %d | Menunggak : %d\n", total, aktif, tunggak
}
' "$DB"
echo "===================================================================="
read -p "Klik Enter..."
}

update_status() {
echo "========== UPDATE =========="
read -p "Nama        : " nama
read -p "Status Baru : " status
status=$(echo "$status" | tr '[:upper:]' '[:lower:]')
if [[ "$status" != "aktif" && "$status" != "menunggak" ]]; then
  echo "[X] Status harus Aktif/Menunggak"
  read -p "Klik Enter..."
  return
fi
awk -F',' -v nama="$nama" -v status="$status" '
BEGIN { OFS="," }
{
    if (tolower($1) == tolower(nama)) {
        $5 = status
    }
    print
}' "$DB" > temp.csv && mv temp.csv "$DB"

echo "Status berhasil diupdate"
read -p "Klik Enter..."
}

laporan() {
aktif=0
tunggak=0

while IFS=',' read -r nama kamar harga tanggal status
do
if [[ "$status" == "aktif" ]]; then
  ((aktif+=harga))
elif [[ "$status" == "menunggak" ]]; then
  ((tunggak+=harga))
fi
done < "$DB"

echo "========== LAPORAN =========="
echo "Total Pemasukan : Rp$aktif"
echo "Total Tunggakan : Rp$tunggak"

echo "===== LAPORAN BULANAN =====" > "$LAPORAN"
echo "Pemasukan : Rp$aktif" >> "$LAPORAN"
echo "Tunggakan : Rp$tunggak" >> "$LAPORAN"

read -p "Klik Enter..."
}

kelola_cron() {
while true
do
echo "========== CRON =========="
echo "1. Lihat Cron Job Aktif"
echo "2. Tambah Cron Job Pengingat"
echo "3. Hapus Cron Job Pengingat"
echo "4. Kembali"
read -p "Pilih [1-4]: " c
case $c in
1)
   echo "Jadwal aktif:"
   crontab -l 2>/dev/null || echo "Belum ada cron"
   ;;
2) read -p "Masukkan jam (0-23): " jam
   read -p "Masukkan menit (0-59): " menit
   if ! [[ "$jam" =~ ^[0-9]+$ ]] || ! [[ "$menit" =~ ^[0-9]+$ ]]; then
    echo "[X] Harus angka!"
    continue
   fi
   if (( jam < 0 || jam > 23 || menit < 0 || menit > 59 )); then
    echo "[X] Jam/menit tidak valid!"
    continue
   fi
   (crontab -l 2>/dev/null | grep -v kost_slebew.sh; \
   echo "$menit $jam * * * $(pwd)/kost_slebew.sh --check") | crontab -
   echo "Cron diset jam $jam:$menit"
   ;;
3) crontab -l 2>/dev/null | grep -v kost_slebew.sh | crontab -
   echo "Cron dihapus"
   ;;
4) break ;;
*)
echo "[X] Pilihan tidak valid"
;;
esac
echo ""
read -p "Klik Enter..."
done
}

while true
do
clear
echo "======================================="
echo "      SISTEM MANAJEMEN KOST SLEBEW      "
echo "======================================="
echo "1. Tambah Penghuni"
echo "2. Hapus Penghuni"
echo "3. Tampilkan Daftar"
echo "4. Update Status"
echo "5. Laporan Keuangan"
echo "6. Kelola Cron"
echo "7. Exit"
echo "======================================="

read -p "Pilih [1-7]: " pilih

case $pilih in
1) tambah_penghuni ;;
2) hapus_penghuni ;;
3) tampilkan ;;
4) update_status ;;
5) laporan ;;
6) kelola_cron ;;
7) exit ;;
*) echo "[X] Pilihan tidak valid"; sleep 1 ;;
esac
done
