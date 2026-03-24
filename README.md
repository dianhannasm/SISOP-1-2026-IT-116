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
    FS = ","
    opsi = ARGV[2]
    delete ARGV[2]
}
```

- `FS` →  Field Separator
- `ARGV` → array berisi argumen dari command line, command line yang digunakan adalah `awk -f KANJ.sh passenger.csv a`
- `ARGV[2]` → a
- `opsi = ARGV[2]` → menyimpan pilihan user (a/b/c/d/e) ke variabel `opsi`
- `delete ARGV[2]` → menghapus argumen opsi supaya tidak dibaca sebagai file dan hanya dipakai sebagai parameter

**Opsi a – Menghitung Jumlah Penumpang**  

```awk
NR > 1 {
    if (opsi == "a" && $1) {
        jumlah++
    }
```

- `NR > 1` → hanya memproses data selain header (baris pertama diabaikan)
- `opsi == "a"` → dijalankan jika user memilih opsi a
- `$1` → memastikan kolom nama tidak kosong
- `jumlah++` → menambahkan jumlah penumpang tiap baris

**Opsi b - Menghitung Jumlah Gerbong**

```awk
if (opsi == "b" && $4) {
        gsub(/\r/, "", $4)
        gsub(/^ +| +$/, "", $4)
        gerbong[$4]++
    }
```

- `opsi == "b"` → dijalankan jika user memilih opsi b
- `$4` → kolom gerbong
- `gsub(/\r/, "", $4)` → menghapus karakter carriage return
- `gsub(/^ +| +$/, "", $4)` → menghapus spasi di awal dan akhir
- `gerbong[$4]++` → menyimpan nilai gerbong ke array

**Opsi c - Mencari Penumpang Tertua**

```awk
if (opsi == "c") {
        if ($2+0 > max) {
            max = $2
            oldest = $1
        }
    }
```

- `opsi == "c"` → dijalankan jika user memilih opsi c
- `$2` → kolom usia
- `$2+0` → konversi ke numerik
- `max` → menyimpan usia tertinggi
- `oldest` → menyimpan nama penumpang tertua

**Opsi d - Menghitung Rata-rata Usia**

```awk
if (opsi == "d" && $2) {
        sum += $2
        count++
    }
```
