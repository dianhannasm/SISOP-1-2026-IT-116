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
    
**Download file** `passenger.csv`
  
  ```bash
  wget -O passenger.csv "https://docs.google.com/spreadsheets/d/1NHmyS6wRO7To7ta-NLOOLHkPS6valvNaX7tawsv1zfE/export?format=csv&gid=0"
  ```
---
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

