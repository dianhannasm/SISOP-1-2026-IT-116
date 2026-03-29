# SISOP-1-2026-IT-116
Dian Hanna Simanjuntak (5027251116)
## Reporting

### Soal 1 - Argo Ngawi Jesgejes
Soal ini meminta untuk menganalisis data penumpang pada file `passenger.csv` berdasarkan opsi yang diberikan (a/b/c/d/e).    
Opsi (a/b/c/d/e):
- a → jumlah seluruh penumpang  
- b → jumlah gerbong  
- c → penumpang tertua  
- d → rata-rata usia  
- e → jumlah penumpang Business
    
**Download File** `passenger.csv`
  
  ```bash
  wget -O passenger.csv "https://docs.google.com/spreadsheets/d/1NHmyS6wRO7To7ta-NLOOLHkPS6valvNaX7tawsv1zfE/export?format=csv&gid=0"
  ```

**Bagian BEGIN (Inisialisasi)**

```awk
BEGIN {
    FS = ","         #Field Separator
    opsi = ARGV[2]
    delete ARGV[2]
}
```
  
- `ARGV` → array berisi argumen dari command line, command line yang digunakan adalah `awk -f KANJ.sh passenger.csv a`
- `ARGV[2]` → a
- `opsi = ARGV[2]` → menyimpan pilihan user (a/b/c/d/e) ke variabel `opsi`
- `delete ARGV[2]` → menghapus argumen opsi supaya tidak dibaca sebagai file dan hanya dipakai sebagai parameter

**Opsi a – Menghitung Jumlah Penumpang**  

```awk
NR > 1 {                         #Mengabaikan baris pertama (header)
    if (opsi == "a" && $1) {
        jumlah++
    }
```

Bagian ini digunakan untuk menghitung jumlah penumpang dengan menjumlahkan setiap baris selain header.  

**Opsi b - Menghitung Jumlah Gerbong**

```awk
if (opsi == "b" && $4) {
        gsub(/\r/, "", $4)        #Menghapus carriage return
        gsub(/^ +| +$/, "", $4)   #Menghapus spasi di awal dan akhir
        gerbong[$4]++             #Simpan nilai gerbong ke array
    }
```

Bagian ini digunakan untuk menghitung jumlah gerbong unik dengan membersihkan data terlebih dahulu, lalu menyimpannya ke dalam array agar tidak terjadi duplikasi.  

**Opsi c - Mencari Penumpang Tertua**

```awk
if (opsi == "c") {
        if ($2+0 > max) { #$2+0 - konversi ke numerik
            max = $2
            oldest = $1
        }
    }
```
Bagian ini membandingkan nilai usia pada setiap baris dan menyimpan nilai terbesar yang ditemukan, beserta nama penumpangnya.  

**Opsi d - Menghitung Rata-rata Usia**

```awk
if (opsi == "d" && $2) {
        sum += $2
        count++
    }
```

Bagian ini digunakan untuk menghitung rata-rata usia dengan menjumlahkan seluruh data usia dan menghitung banyaknya data.  

**Opsi e - Menghitung Penumpang Business Class**  

```awk
if (opsi == "e" && $3 == "Business") {
        business++
    }
```

Bagian ini digunakan untuk menghitung jumlah penumpang kelas Business dengan memfilter data (hanya data dengan nilai "Business" pada kolom kelas yang akan dihitung).  

**Output**
```awk
END {
    if (opsi == "a") {
        print "Jumlah seluruh penumpang KANJ adalah ", jumlah, " orang"
    }
    else if (opsi == "b") {
        print "Jumlah gerbong penumpang KANJ adalah ", length(gerbong)
    }
    else if (opsi == "c") {
        print oldest, " adalah penumpang kereta tertua dengan usia ", max, " tahun"
    }
    else if (opsi == "d") {
        printf "Rata-rata usia penumpang adalah %.0f tahun\n", sum/count
    }
    else if (opsi == "e") {
        print "Jumlah penumpang business class ada ", business, " orang"
    }
    else {
        print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."
        print "Contoh penggunaan: awk -f file.sh data.csv a"
    }
}
```

Bagian ini digunakan untuk menampilkan hasil akhir berdasarkan opsi yang dipilih oleh user.  

Jika user memasukkan opsi selain a, b, c, d, atau e, maka program akan menampilkan pesan error sebagai berikut:

```text
Soal tidak dikenali. Gunakan a, b, c, d, atau e.
Contoh penggunaan: awk -f file.sh data.csv a
```
  
<img width="1718" height="686" alt="image" src="https://github.com/user-attachments/assets/860bc66c-353d-4b3f-916b-d7a58b274b76" />

---  
### Soal 2 - Ekspedisi Pesugihan Gunung Kawi - Mas Amba   
Pada soal ini, dilakukan ekspedisi pencarian benda pusaka dengan melakukan perhitungan koordinat lokasi pusaka
  
**Download File**  
Langkah pertama adalah menyiapkan toolsnya, yaitu `gdown`.  
```bash
sudo apt update
sudo apt install python3-pip -y
python3 -m venv env
source env/bin/activate
pip install gdown
```

Setelah ini, dibuat folder `ekspedisi` dan file `peta-ekspedisi-amba.pdf` diunduh di folder tersebut.  
```bash
mkdir ekspedisi
cd ekspedisi
gdown "https://drive.google.com/uc?id=1q10pHSC3KFfvEiCN3V6PTroPR7YGHF6Q"
```
  
**Bedah Isi File**  
```bash
cat peta-ekspedisi-amba.pdf
```
dari hasil bedah isi file ditemukan sebuah link, yaitu:  
```bash
https://github.com/pocongcyber77/peta-gunung-kawi.git
```
  
**Clone Repository**  
Link tersebut kemudian di-clone.
```bash
git clone https://github.com/pocongcyber77/peta-gunung-kawi.git
cd peta-gunung-kawi
```
Di dalam repository terdapat file `gsxtrack.json` yang berisi data koordinat.

**Parsing Data**  
File `gsxtrack.json` berisi beberapa titik lokasi dengan atribut seperti `id`, `site_name`, `latitude` dan `longitude`.  
Untuk mengekstrak data tersebut, dibuat `parserkoordinat.sh`:
```bash
#!/bin/bash

awk -F'"' '
/"id"/ {
id=$0
gsub(/.*"id": "/, "", id) 
gsub(/",?/, "", id)       
}
/"site_name"/ {
site=$0
gsub(/.*"site_name": "/, "", site)
gsub(/",?/,"", site)
}
/"latitude"/ {
lat=$0
gsub(/.*"latitude": /, "", lat)
gsub(/,/, "", lat)
}
/"longitude"/ {
lon=$0
gsub(/.*"longitude": /, "", lon)
gsub(/,/, "", lon)

printf "%s, %s, %s, %s\n", id, site, lat, lon
}
' gsxtrack.json > titik-penting.txt
```
Script ini menggunakan `awk` untuk membaca file dan `gsub` untuk membersihkan teksnya.  
Output disimpan dalam file `titik-penting.txt`  
<img width="1714" height="175" alt="image" src="https://github.com/user-attachments/assets/bc9d696d-40f7-4461-bd29-a4dfe587c268" />

**Lokasi Pusaka**  
Keempat titik koordinat membentuk persegi. Lokasi pusaka berada di titik tengah diagonalnya.  
Dibuat script `nemupusaka.sh`:  
```bash
#!/bin/bash

lat1=$(sed -n '1p' titik-penting.txt | awk -F',' '{print $3}')
lon1=$(sed -n '1p' titik-penting.txt | awk -F',' '{print $4}')

lat3=$(sed -n '3p' titik-penting.txt | awk -F',' '{print $3}')
lon3=$(sed -n '3p' titik-penting.txt | awk -F',' '{print $4}')

mid_lat=$(echo "($lat1 + $lat3)/2" | bc -l)
mid_lon=$(echo "($lon1 + $lon3)/2" | bc -l)

printf "Koordinat pusat:\n%.5f, %.5f\n" $mid_lat $mid_lon > posisipusaka.txt
```  
- `sed -n '1p'` mengambil baris pertama
- `awk -F','` memisahkan data berdasarkan koma
- `{print $3}` mengambil kolom ke-3
- `bc -l` melakukan perhitungan desimal

**Hasil Akhir**  
Hasil perhitungan disimpan ke `posisipusaka.txt`:  
<img width="1711" height="115" alt="image" src="https://github.com/user-attachments/assets/788c1b81-a075-4c89-a7df-6e0225d25373" />

---
### Soal 3 - Kost Slebew Ambatukam  
Pada soal ini, dibuat sebuah sistem manajemen kost untuk membantu pengelolaan data penghuni kost.  
**Inisialisasi Path File**  
Pada bagian ini, dilakukan pendefinisian beberapa variabel yang berisi path file yang digunakan dalam program.  
```bash
DB="data/penghuni.csv"
LOG="log/tagihan.log"
HISTORY="sampah/history_hapus.csv"
LAPORAN="rekap/laporan_bulanan.txt"
```
**Cek Tagihan**  
Fungsi ini digunakan untuk mengecek data penghuni yang memiliki status menunggak, kemudian mencatatnya ke dalam file log.  
```bash
check_tagihan() {
while IFS=',' read -r nama kamar harga tanggal status
do
  if [[ "$status" == "menunggak" ]]; then
     echo "[$(date '+%F %T')] TAGIHAN: $nama (Kamar $kamar) Menunggak Rp$harga" >> "$LOG"
  fi
done < "$DB"
}
```
Bagian ini digunakan untuk menjalankan fungsi check_tagihan secara otomatis melalui parameter saat script dijalankan (langsung ngecek tagihan tanpa masuk menu).  
```bash
if [[ "$1" == "--check" ]]; then
  check_tagihan
  exit
fi
```
**Fitur Tambah Penghuni**  
*Tampilan Header & Input Data*  
Menampilkan judul agar user tahu sedang berada di menu tambah penghuni dan menerima input dari user yang kemudian data disimpan ke variabel.  
```bash
echo "=============================="
echo "       TAMBAH PENGHUNI        "
echo "=============================="

read -p "Nama                           : " nama
read -p "Nomor Kamar                    : " kamar
read -p "Harga Sewa                     : " harga
read -p "Tanggal Masuk (YYYY-MM-DD)     : " tanggal
read -p "Status Awal (Aktif/Menunggak)  : " stat
```
*Validasi Data*  
```bash
if ! [[ $harga =~ ^[0-9]+$ ]]; then             #memastikan harga harus angka positif
  echo "[X] Harga harus angka!"
  read -p "Klik Enter..."
  return
fi

if ! date -d "$tanggal" >/dev/null 2>&1; then    #memastikan format tanggal benar
  echo "[X] Format tanggal salah!"
  read -p "Klik Enter..."
  return
fi

if [[ "$tanggal" > "$(date +%F)" ]]; then        #memastikan tidak bisa input tanggal masa depan
  echo "[X] Tidak boleh tanggal masa depan!"
  read -p "Klik Enter..."
  return
fi

if grep -q ",$kamar," "$DB"; then                #mencegah nomor kamar duplikat
  echo "[X] Kamar sudah terisi!"
  read -p "Klik Enter..."
  return
fi

status=$(echo "$status" | tr '[:upper:]' '[:lower:]')            #mengubah input jadi huruf kecil
if [[ "$status" != "aktif" && "$status" != "menunggak" ]]; then  #memastikan hanya dua pilihan, aktif/menunggak
  echo "[X] Status harus Aktif/Menunggak"
  read -p "Klik Enter..."
  return
fi
```
*Simpan ke Database*  
Menambahkan ke file (append).  
```bash
echo "$nama,$kamar,$harga,$tanggal,$status" >> "$DB"

echo "Berhasil ditambahkan!"                            #memberi feedback ke user
read -p "Klik Enter..."
}
```

**Fitur Hapus Penghuni**  
Fungsi ini digunakan untuk menghapus data penghuni dari database utama, namun sebelum dihapus, datanya akan dipindahkan terlebih dahulu ke file `history_hapus.csv`.  
```bash
hapus_penghuni() {
echo "========== HAPUS =========="                    #haeder
read -p "Nama penghuni yang akan dihapus: " nama      #input nama
tanggal=$(date +%F)                                   #ambil tanggal sekarang untuk mencatat kapan data dihapus
awk -F',' -v nama="$nama" -v tgl="$tanggal" '        
BEGIN{OFS=","}
tolower($1)==tolower(nama){
print $0,tgl >> "'$HISTORY'"                          #simpan ke history
}
' "$DB"

sed -i "/^$nama,[^,]*,/Id" "$DB"                      #baris dengan nama tersebut akan dihapus dari file database

echo "Data dipindah ke history & dihapus"             #feedback ke user
read -p "Klik Enter..."
}
```

**Fitur Tampilkan**
Fungsi ini digunakan untuk menampilkan seluruh data penghuni.  
