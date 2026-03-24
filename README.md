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
