BEGIN {
    FS = ","
    opsi = ARGV[2]
    delete ARGV[2]
}

NR > 1 {
    if (opsi == "a" && $1) {
        jumlah++
    }
    if (opsi == "b" && $4) {
        gsub(/\r/, "", $4)
        gsub(/^ +| +$/, "", $4)
        gerbong[$4]++
    }
    if (opsi == "c") {
        if ($2+0 > max) {
            max = $2
            oldest = $1
        }
    }
    if (opsi == "d" && $2) {
        sum += $2
        count++
    }
    if (opsi == "e" && $3 == "Business") {
        business++
    }
}

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

